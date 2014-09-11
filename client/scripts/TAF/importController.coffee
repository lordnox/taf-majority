
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

.controller 'tafImportCtrl', [
  '$scope', '$sessionStorage', '$localStorage',
  ($scope, $sessionStorage, $localStorage) ->
    window.s = $scope;
    $scope.lStore = $localStorage
    $scope.sStore = $sessionStorage

    init = ->
      $localStorage.$default
        tournaments: []
      $sessionStorage.$default
        tournament: {}
      $scope.text = 'TAF Westdeutsche Meisterschaft Discofox - Tanzen im Dreiländereck 2014

Am 14.06.2014 in Aachen.
Hgr. C Discofox          markierte Paare erhalten eine Platzierung

Endergebnis
Platz Starter / Institution
Endrunde  Df  PZ
1.  22  Marie-Luise Planert / Christopher Mettken (11)
TSC Imperial Mülheim an der Ruhr e.V., Mülheim an der Ruhr  32211
1.0 1.0
2.  20  Henning Schall / Lena Thometzek (13)
TanzTreff Jülich, Titz  11423
2.0 2.0
3.  18  Tobias Wegner / Leonie Hackenberg (94)
Turnverein Cannstatt 1846 e.V., Stuttgart 23154
3.0 3.0
4.  16  Sebastian Wittgens / Kristina Pickartz (17)
TSC Grün-Weiss Aquisgrana Aachen, Aachen  44342
4.0 4.0
5.  14  Lutz Menzel / Sandra Forejt (9)
Tanz-Turnier-Club Oberhausen e. V., Oberhausen  55535
5.0 5.0
6.  12  Dirk Kietzmann / Melanie Kietzmann (8)
Tanz-Turnier-Club Oberhausen e. V., Oberhausen  66666
6.0 6.0
1. Zwischenrunde
7.  10  Hartmut Wolf / Susanne Wolf (18)  ADTV-Club-Tanzschule Geza Lang, Lüdenscheid
8.-11.  6 Patrick Gerber / Stephanie Gerber (6) TC Seidenstadt e.V., Krefeld
8.-11.  6 Frank Herzog / Heidrun Herzog (7) TSG Baunatal TSA des GSV Eintracht und KSV Baunatal, Baunatal
8.-11.  6 Frank Rößler / Birgit Kirchhelle (12) Tanzsportclub Dortmund e.V., Dortmund
8.-11.  6 Ilona Tremmel / Hans Tremmel (15) ADTV Tanzschule Harry Hagen, Bietigheim-Bissingen
Hoffnungsrunde
12.

0

Anke Strietzel / Kevin Abel (14)  ADTV Tanzschule Mettler, Oberhausen

Wertungsrichter
Eren Dogan (EDanceFever), Silvia Kreuz (TC Blau Gold Solingen), Vicky Legaki (Tanzkultur), Daniel Reichling (TSC Brühl), Marco Schmitz (Tanzen wo es Spass macht Koblenz)
Turnierleitung
TL: Dirk Mettler (ADTV-Tanzschule Mettler), SV: Andreas Krug (RSV Seeheim)
Diese Liste wurde mit TopTurnier für Windows V7.4b erstellt.'
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
]