
findInfo = (test) ->
  console.log "===========> find Information"
  exp = XRegExp '(?<title>[\\p{L}\\p{N}\\s\\/]+)\\s+' +
                'Am\\s+(?<date>\\d\\d\\.\\d\\d\\.(:?\\d\\d)?\\d\\d)\\s+' +
                # '(?<location>[\\p{L}\\p{N}\\s\\/]+)' +
                ''

  match = XRegExp.exec test, exp, 0
  console.log match
  return {} if not match

  title    : match.title.trim()
  date     : match.date
  location : match.location

findJudges = (test) ->
  console.log "===========> find Judges"
  pos = Math.max 0, test.indexOf "Wertungsrichter"
  pos += "Wertungsrichter".length
  endPos = Math.min test.length - 1, test.indexOf "Turnierleitung"

  exp = XRegExp '(?<name>[\\p{L}\\s]+)\\s+' +
                '\\((?<club>[\\p{L}\\s,]+)\\)\\,?\\s+' +
                ''

  matches = []
  index = 0
  while pos < endPos && match = XRegExp.exec test, exp, pos
    console.log match
    pos = match.index + match[0].length
    index++
    matches.push
      name: match.name.trim()
      club: match.club.trim()
      letter: String.fromCharCode 64 + index

  matches

findCouples = (test) ->
  console.log "===========> find Couples"
  pos = Math.max 0, test.indexOf "Endrunde"

  exp = XRegExp '(?<Endrunde>Endrunde)\\s+' +
                '(?<SD>SD)?\\s+' +
                '(?<DF>Df)?\\s+' +
                '(?<KR>K)?\\s+'
        , 'i'
  dances = XRegExp.exec test, exp, pos

  return if not dances

  expStr = '(?<place>[1-8])\\.\\s+' +
           '(?<points>\\d+)\\s+' +
           '(?<names>[\\p{L}\\p{N}\\s-\\/]+)' +
           '\\((?<unknown>\\d+)\\)\\s*' +
           '(?<club>[_\\-\\.\\p{L}\\s]+),\\s' +
           '(?<clublocation>[\\p{L}\\s-]+)\\s+'

  if dances.SD
    expStr += '(?<sdValues>\\d+)\\s+' +
              '(?<sdPZ>[\\d\\.]+)\\s+'
  if dances.DF
    expStr += '(?<dfValues>\\d+)\\s+' +
              '(?<dfPZ>[\\d\\.]+)\\s+'
  if dances.KR
    expStr += '(?<krValues>\\d+)\\s+' +
              '(?<krPZ>[\\d\\.]+)\\s+'

  expStr += '(?<pz>[\\d\\.]+)\\s*'

  exp = XRegExp expStr

  couples = []

  while match = XRegExp.exec test, exp, pos
    console.log match
    pos = match.index + match[0].length
    names = match.names.trim().split '/'
    nameL = names[1].trim()
    nameF = names[0].trim()
    couple =
      place: match.place
      points: match.points
      names:
        leader: nameL
        follower: nameF
      unknown: match.unknown
      club:
        name: match.club
        location: match.clublocation
      PZ: match.pz
    if dances.SD
      couple.SD =
        values: match.sdValues.split ''
        pz: match.sdPZ
    if dances.DF
      couple.DF =
        values: match.dfValues.split ''
        pz: match.dfPZ
    if dances.KR
      couple.KR =
        values: match.krValues.split ''
        pz: match.krPZ

    couples.push couple
  couples

test2data = (test) ->
  information: findInfo test
  couples: findCouples test
  judges: findJudges test


angular.module('taf.controller.import', ['ngStorage'])

.controller 'tafImportCtrl', ($scope, $sessionStorage, $localStorage, tafCalculation) ->
  $scope.lStore = $localStorage
  $scope.sStore = $sessionStorage

  init = ->
    $localStorage.$default
      tournaments: []
    $sessionStorage.$default
      tournament: {}
    $scope.text = ''
    $scope.data = {}
    $scope.updateData $scope.text

  $scope.open = 0

  $scope.isOpen = (index) -> $scope.open is index
  $scope.toggleOpen = (index) -> $scope.open = if $scope.isOpen index then false else index

  $scope.updateData = (text) ->
    $scope.data = test2data text

  $scope.import = (data) ->
    $localStorage.tournaments.unshift data
    init()

  $scope.load = (tournament) ->
    $sessionStorage.tournament = tournament

  $scope.reset = ->
    $localStorage.$reset()
    $sessionStorage.$reset()
    init()

  $scope.remove = (index, $event) ->
    $localStorage.tournaments.splice index, 1

  init()
