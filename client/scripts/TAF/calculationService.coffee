
angular.module('taf.services.calculation', [])

.factory 'tafCalculation', ->
  class Calculation
    reset: ->
      @dances = ['SD', 'DF', 'KR']
      #@dances = ['DF']
      @maxPlace = 0
      @SD =
        places: {}
        couples: {}
        data: []
        unplaced: {}
        placements: {}
        errors: []
      @DF =
        places: {}
        couples: {}
        data: []
        unplaced: {}
        placements: {}
        errors: []
      @KR =
        places: {}
        couples: {}
        data: []
        unplaced: {}
        placements: {}
        errors: []

    getUnplacedCouples: (dance) ->
      Object.keys(@[dance].unplaced).map (i) -> parseInt i, 10
      # [1, 4, 5]

    placeCouple: (dance, couple, place) ->
      Couple = @tournament.couples[couple]
      console.info '(%s:%d) Place %d goes to: %s, %s!', dance, 1+place, 1+place, Couple.names.follower, Couple.names.leader
      @[dance].places[place] = @[dance].places[place] || []
      @[dance].places[place].push couple
      @[dance].couples[couple] = place
      delete @[dance].unplaced[couple]

    loadTournamentData: ->
      @majority = Math.ceil @tournament.judges.length / 2
      @maxPlace = @tournament.couples.length - 1
      @tournament.couples.forEach (couple, index) =>
        @dances.forEach (dance, i) =>
          # if one couple is missing the data for a danc, remove it from the dances-list
          return @dances.splice i, 1 if not couple.hasOwnProperty dance
          @[dance].data[index] = couple[dance].values.map (val) -> parseInt val, 10
          @[dance].unplaced[index] = index
          @[dance].placements[index] = []

    countAndSumData: (dance) ->
      places = @[dance].data.length
      @[dance].data.forEach (data, couple) =>
        place = places
        while place-->0
          filtered = data.filter (i) -> i <= place + 1
          @[dance].placements[couple][place] =
            count: filtered.length
            sum: filtered.reduce ((a, b) -> a + b), 0

    stepCouples: (dance, couples, place, basePlace, init, filter, split) ->
      # place the couple if only one is given
      if couples.length is 1
        @placeCouple dance, couples[0], basePlace
        return 1

      # initialize the dataset
      obj = @getPlacementData dance, couples, place
      # run the init callback to find our target
      target = init.call obj
      if target is false
        console.log '(%s:%d) Stepping through %s, no target found, increasing place', dance, 1+place, dance
        if place < @maxPlace
          return @stepCouples dance, couples, place + 1, basePlace, init, filter, split
        return false

      console.log '(%s:%d) Stepping through %s to find %d', dance, 1+place, dance, target

      splitCouples = []
      restCouples = []

      # add the couples to one of the lists
      obj.couples.forEach (couple, index) ->
        (if target is filter.call obj, couple, index then splitCouples else restCouples).push couple

      # if only one couple is found, place it
      if splitCouples.length is 1
        console.log '(%s:%d) Found only couple %d with %d', dance, 1+place, splitCouples[0], target
        @placeCouple dance, splitCouples[0], basePlace++
        place = Math.max place, basePlace
        # re-run with the rest couples
        return 1 + @stepCouples dance, restCouples, place, basePlace, init, filter, split

      console.log "(%s:%d) Found %d couples, trying next rule", dance, 1+place, splitCouples.length, splitCouples

      # if we have more
      split.call @, splitCouples, place, basePlace, obj
      basePlace += splitCouples.length
      place = Math.max place, basePlace
      # re-run with the rest couples
      return splitCouples.length + @stepCouples dance, restCouples, place, basePlace, init, filter, split if restCouples.length
      0


    findMinSum: (dance, couples, place, basePlace) ->
      @stepCouples dance, couples, place, basePlace
      # initialize with min value
      , (-> Math.min.apply null, @sums)
      # check min against the sums
      , ((couple, index) -> @sums[index])
      , ((couples, place, basePlace, obj) ->
          if place < @maxPlace
            console.log "(%s:%d) Resuming with rule findMinSum [findMinSum]", dance, 1+place
            return @findMinSum dance, couples, place + 1, basePlace
          console.log "(%s:%d) Stopping to place %d couples", dance, 1+place, couples.length
          couples.forEach (couple) =>
            @placeCouple dance, couple, basePlace
        )

    findMaxCount: (dance, couples, place, basePlace) ->
      majority = @majority
      @stepCouples dance, couples, place, basePlace
      # initialize with max value
      , (->
          max = Math.max.apply null, @counts
          if max >= majority then max else false
        )
      # check max against the counts
      , ((couple, index) -> @counts[index])
      , ((couples, place, basePlace) ->
          console.log "(%s:%d) Resuming with rule findMinSum [findMaxCount]", dance, 1+place
          @findMinSum dance, couples, place, basePlace
        )

    findPlacement: (dance, couples, place, basePlace) ->
      return @findMaxCount dance, couples, place, basePlace

    getPlacementData: (dance, couples, place) ->
      counts = []
      sums = []
      couples.forEach (couple) =>
        counts.push @[dance].placements[couple][place].count
        sums.push   @[dance].placements[couple][place].sum

      couples : couples
      counts  : counts
      sums    : sums

    findPlacements: (dance) ->
      console.log "finding placements for %s", dance
      places = @[dance].data.length
      place = 0
      while places > place
        innerPlace = place
        couples = @getUnplacedCouples dance
        return if not couples.length
        found = false
        while found is false and innerPlace < places
          found = @findPlacement dance, couples, innerPlace, place
          console.log 'found?', found
          innerPlace++

        place += found

        if found is false
          console.error "Something bad happend"
          place = Infinity

    constructor: (@tournament) ->
      console.log '===> Tournament: %s', @tournament.information.title

      @reset()
      @loadTournamentData()
      @dances.forEach (dance) => @countAndSumData dance
      @dances.forEach (dance) => @findPlacements dance

    result: ->
      couples = @tournament.couples
      @dances.forEach (dance) =>
        Dance = @[dance]
        Object.keys(Dance.places).forEach (place) ->
          placement = parseInt place, 10
          placement = (1 + Dance.places[place].length) / 2 + placement
          placement = (placement + '.0').substr 0, 3
          Dance.places[place].forEach (index) ->
            couple = couples[index]
            couple[dance].placements = Dance.placements[index]
            couple[dance].place = placement

  Calculation