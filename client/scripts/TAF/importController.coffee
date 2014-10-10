
findInfo = (test) ->
  console.log "===========> find Information"
  exp = XRegExp '(?<title>[\\p{L}\\p{N}\\s\\/]+)\\s+' +
                'Am\\s+(?<date>\\d\\d\\.\\d\\d\\.(:?\\d\\d)?\\d\\d)\\s+' +
                '(?:in)?\\s+(?<location>[\\p{L}\\p{N}\\s\\/]+)' +
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
                '\\((?<club>[^\\)]+)\\)\\,?\\s+' +
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
  pos = 0

  exp = XRegExp '(?<Endrunde>Endrunde)\\s+' +
                '(?<SD>SD\\s+)?' +
                '(?<DF>Df\\s+)?' +
                '(?<KR>K\\s+)?'
        , 'i'
  dances = XRegExp.exec test, exp, pos

  return if not dances

  expStr = '(?<place>[1-8])\\.\\s+' +
           '(?<points>\\d+|\\S+)\\s+' +
           '(?<names>[\\p{L}\\p{N}\\s-\\/]+)' +
           '\\((?<number>\\d+)\\)\\s*' +
           '(?<club>[_\\-\\.\\d\\p{L}\\s]+,\\s)?' +
           '(?<clublocation>[\\p{L}\\s-\\d]+)\\s+'

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
      number: match.number
      club:
        name: match.club
        location: match.clublocation
      PZ: match.pz
    if dances.SD
      couple['SLOW-DF'] =
        values: match.sdValues.split ''
        pz: match.sdPZ
    if dances.DF
      couple['DISCOFOX'] =
        values: match.dfValues.split ''
        pz: match.dfPZ
    if dances.KR
      couple['KUER'] =
        values: match.krValues.split ''
        pz: match.krPZ

    couples.push couple
  couples

test2data = (test) ->
  information: findInfo test
  couples: findCouples test
  judges: findJudges test

angular.module('taf.controller.import', ['ngStorage'])

.controller 'tafImportCtrl', ($scope, $sessionStorage, $localStorage, tafTournament) ->
  $scope.lStore = $localStorage
  $scope.sStore = $sessionStorage

  init = ->
    $localStorage.$default
      tournaments: []
    $sessionStorage.$default
      tournament: {}
    $scope.text = 'TAF German Masters Discofox 2014

Am 20.09.2014 in Mülheim.
Hgr. B Discofox          markierte Paare erhalten eine Platzierung         markierte Paare erhalten die DM Qualifikation          markierte Paare haben bereits die DM Qualifikation

Endergebnis
Platz Starter / Institution
Endrunde  SD  Df  PZ
1.  26  Annika Westedt / Tobias Kopelke (43)
Discofox Club Hamburg, Hamburg  63712
3.0 25712
1.0 4.0
2.  24  Benjamin Zentz / Anastasia Zentz (47)
Tanzschule hp-dancecompany, Bad Kreuznach 56231
2.0 33131
2.0 4.0
3.  22  Erika Keller / Christian Keller (12)
ADTV Tanzschule Harry Hagen, Bietigheim-Bissingen 12627
1.0 61547
6.0 7.0
4.  20  Marie-Luise Planert / Christopher Mettken (44)
TSC Imperial Mülheim an der Ruhr e.V., Mülheim an der Ruhr  35346
6.0 16323
3.0 9.0
5.  18  Steffi Beier / Tim La Civita (48)
Tanzschule HAPPY HOURS, Hannover  41453
4.0 72455
5.0 9.0
6.  16  Tobias Wegner / Leonie Hackenberg (15)
Turnverein Cannstatt 1846 e.V., Stuttgart 27164
5.0 47274
4.0 9.0
7.  14  Giulio Arancio / Gina Johannsen (51)
ADTV Tanzschule van Hasselt GmbH, Köln  74575
7.0 54666
7.0 14.0
1. Zwischenrunde
8.  12  Marcel Mock / Jessica Lynen (40)  TanzTreff Jülich, Jülich
9.  10  Nick Winkelmann / Katharina Nack (41) Tanzschule HAPPY HOURS, Hannover
10.-11. 6 Henning Schall / Lena Thometzek (42)  TanzTreff Jülich, Jülich
10.-11. 6 Mirko Kobrig / Ewelina Wolniak (49) Tafa Solingen GmbH, Solingen
Hoffnungsrunde
12.-13. 2 Monika Siemer / Axel Siemer (45)  ADTV Tanzschule Harry Hagen, Bietigheim-Bissingen
12.-13. 2 Mike Emmel / Carmen Wolf (46) TanzCentrO, Oberhausen
14. 0 Michael Becker / Melissa Becker (50)  Tanz-Turnier-Club Oberhausen e. V., Oberhausen

Wertungsrichter
Gabi Kerner (ADTV Tanzschule Mettler, Oberhausen), Jose-Francisco Esquinas-Gomez (Tanzschule Vö, Heilbronn), Michael Panhey (TSC Imperial Mülheim), Geza Lang (ADTV Club-Tanzschule Geza Lang), Rouven Grassel (TTC Oberhausen)
Turnierleitung
TL: Franz Jansen (ADTV Altstadt Tanzschule Jansen), SV: Frank Becker (Tanzen Neu Erleben Neuss)
Diese Liste wurde mit TopTurnier für Windows V7.5b erstellt.'
    $scope.data = {}
    $scope.updateData $scope.text


  $scope.open = 0

  $scope.isOpen = (index) -> $scope.open is index
  $scope.toggleOpen = (index) -> $scope.open = if $scope.isOpen index then false else index

  $scope.updateData = (text) ->
    $scope.data = test2data text

  $scope.import = (data) ->
#    $localStorage.tournaments.unshift data
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
  tournament = tafTournament.import $scope.data
  console.log tournament
