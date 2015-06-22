<map version="freeplane 1.2.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node FOLDED="false" ID="ID_1723255651" CREATED="1283093380553" MODIFIED="1434972244839"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <p style="text-align: center">
      config
    </p>
    <p style="text-align: center">
      Singleton
    </p>
  </body>
</html>

</richcontent>
<hook NAME="MapStyle">

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node">
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right">
<stylenode LOCALIZED_TEXT="default" MAX_WIDTH="600" COLOR="#000000" STYLE="as_parent">
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.note"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important">
<icon BUILTIN="yes"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#111111">
<font SIZE="10"/>
</stylenode>
</stylenode>
</stylenode>
</map_styles>
</hook>
<hook NAME="AutomaticEdgeColor" COUNTER="5"/>
<node TEXT="setup" POSITION="right" ID="ID_1664622307" CREATED="1434950212290" MODIFIED="1434978005870">
<edge COLOR="#ff0000"/>
<node TEXT="register module" ID="ID_616217982" CREATED="1434954471397" MODIFIED="1434954517261">
<node TEXT="src" ID="ID_1828909465" CREATED="1434954459116" MODIFIED="1434954460692"/>
<node TEXT="local" ID="ID_43106765" CREATED="1434954455773" MODIFIED="1434954458563"/>
<node TEXT="global" ID="ID_1994971135" CREATED="1434954452957" MODIFIED="1434954454309"/>
<node TEXT="user" ID="ID_1029665869" CREATED="1434954447862" MODIFIED="1434954452674"/>
</node>
<node TEXT="add special path" ID="ID_1150936606" CREATED="1434970016570" MODIFIED="1434970025614"/>
<node TEXT="set schema" ID="ID_211971474" CREATED="1434978016874" MODIFIED="1434978354522"/>
</node>
<node TEXT="search" POSITION="right" ID="ID_55114533" CREATED="1434950217578" MODIFIED="1434978012912">
<edge COLOR="#0000ff"/>
<node TEXT="step through search paths" ID="ID_676070596" CREATED="1434971531266" MODIFIED="1434971601918"/>
<node TEXT="go into array if it is one" ID="ID_1278007155" CREATED="1434971545146" MODIFIED="1434971562821"/>
<node TEXT="use list of found files" ID="ID_1492370648" CREATED="1434972679544" MODIFIED="1434972757012"/>
<node TEXT="set watch on files / directories" ID="ID_775948347" CREATED="1434972771134" MODIFIED="1434972792001"/>
<node TEXT="trigger load content" ID="ID_1373987306" CREATED="1434971580065" MODIFIED="1434971587800"/>
<node TEXT="later is dominant" ID="ID_1152981838" CREATED="1434971693208" MODIFIED="1434972075136"/>
</node>
<node TEXT="load content" POSITION="right" ID="ID_1153941712" CREATED="1434950227699" MODIFIED="1434950233590">
<edge COLOR="#00ff00"/>
<node TEXT="autodetect format" ID="ID_369463749" CREATED="1434977238286" MODIFIED="1434977246069">
<node TEXT="by extension" ID="ID_802815" CREATED="1434977246598" MODIFIED="1434977249987"/>
<node TEXT="by content" ID="ID_146799666" CREATED="1434977250495" MODIFIED="1434977254460"/>
</node>
<node TEXT="different formats" ID="ID_1589152505" CREATED="1434951943166" MODIFIED="1434951947278">
<node TEXT="js" ID="ID_122533272" CREATED="1434955105921" MODIFIED="1434955108774"/>
<node TEXT="json" ID="ID_1203862956" CREATED="1434955109802" MODIFIED="1434955111846"/>
<node TEXT="xml" ID="ID_12275225" CREATED="1434955112089" MODIFIED="1434955114159"/>
<node TEXT="yaml" ID="ID_536219288" CREATED="1434955115017" MODIFIED="1434955116638"/>
<node TEXT="ini" ID="ID_1984699641" CREATED="1434955116921" MODIFIED="1434955118550"/>
</node>
<node TEXT="multiple filse load into one config" ID="ID_1975883840" CREATED="1434954979756" MODIFIED="1434955072656"/>
<node TEXT="load into substructure" ID="ID_715701404" CREATED="1434954992971" MODIFIED="1434955045114"/>
<node TEXT="load complete directory" ID="ID_533835500" CREATED="1434955032770" MODIFIED="1434955038991"/>
<node TEXT="support find settings" ID="ID_1764749829" CREATED="1434955093794" MODIFIED="1434955100272"/>
<node TEXT="auto reload on file changes" ID="ID_454819395" CREATED="1434954906988" MODIFIED="1434954920360"/>
</node>
<node TEXT="validation" POSITION="right" ID="ID_1648591272" CREATED="1434955180544" MODIFIED="1434955183780">
<edge COLOR="#ff0000"/>
<node TEXT="complete" ID="ID_1333421349" CREATED="1434978060033" MODIFIED="1434978069166"/>
<node TEXT="of newly loaded data" ID="ID_1437016462" CREATED="1434978045738" MODIFIED="1434978077480"/>
</node>
<node TEXT="access parts" POSITION="right" ID="ID_1326239621" CREATED="1434950239185" MODIFIED="1434950253954">
<edge COLOR="#ff00ff"/>
<node TEXT="get reference to config or part" ID="ID_266536106" CREATED="1434979803358" MODIFIED="1434979816084"/>
</node>
<node TEXT="events" POSITION="right" ID="ID_855223485" CREATED="1434955127962" MODIFIED="1434955168072">
<edge COLOR="#007c7c"/>
<node TEXT="onReady" ID="ID_297896753" CREATED="1434979849382" MODIFIED="1434979854297">
<node TEXT="first loading done" ID="ID_1578943956" CREATED="1434979859821" MODIFIED="1434979865609"/>
</node>
<node TEXT="onReload" ID="ID_44592344" CREATED="1434955160657" MODIFIED="1434979894184">
<node TEXT="reloaded $path" ID="ID_1827631277" CREATED="1434979869133" MODIFIED="1434979886883"/>
</node>
</node>
<node TEXT="properties" POSITION="left" ID="ID_62069937" CREATED="1434954743432" MODIFIED="1434971662341">
<edge COLOR="#7c007c"/>
<node TEXT="search[]" ID="ID_948564646" CREATED="1434954743432" MODIFIED="1434971636893"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      paths to search in
    </p>
  </body>
</html>
</richcontent>
<node TEXT="{}" ID="ID_1472447050" CREATED="1434971290262" MODIFIED="1434972314541">
<node TEXT="uri" ID="ID_299721938" CREATED="1434970595960" MODIFIED="1434972384273"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      path to load from
    </p>
  </body>
</html>

</richcontent>
<node TEXT="file:///bla..." ID="ID_1387241212" CREATED="1434972411908" MODIFIED="1434972426455">
<node TEXT=".../*" ID="ID_779513710" CREATED="1434972453587" MODIFIED="1434972475518"/>
<node TEXT="../*.yml" ID="ID_1312524921" CREATED="1434972477626" MODIFIED="1434972486518"/>
</node>
<node TEXT="http://...." ID="ID_1192323302" CREATED="1434972427107" MODIFIED="1434972443247"/>
<node TEXT="https://" ID="ID_1383922446" CREATED="1434972444372" MODIFIED="1434972448112"/>
</node>
<node TEXT="config" ID="ID_1328357315" CREATED="1434970096489" MODIFIED="1434972400625"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      path string to include into
    </p>
  </body>
</html>

</richcontent>
</node>
</node>
<node TEXT="[]" ID="ID_1221604305" CREATED="1434971426155" MODIFIED="1434972319796">
<node TEXT="element" ID="ID_537972591" CREATED="1434971434764" MODIFIED="1434972351116">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#000000" WIDTH="2" TRANSPARENCY="80" FONT_SIZE="12" FONT_FAMILY="SansSerif" DESTINATION="ID_1472447050" STARTINCLINATION="77;0;" ENDINCLINATION="77;0;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
</node>
<node TEXT="[]" ID="ID_1811014803" CREATED="1434971442628" MODIFIED="1434972329371">
<node TEXT="element" ID="ID_1755465285" CREATED="1434972331996" MODIFIED="1434972353490">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#000000" WIDTH="2" TRANSPARENCY="80" FONT_SIZE="12" FONT_FAMILY="SansSerif" DESTINATION="ID_1472447050" STARTINCLINATION="117;0;" ENDINCLINATION="117;0;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
</node>
</node>
</node>
</node>
<node TEXT="schema{}" ID="ID_955657676" CREATED="1434977540017" MODIFIED="1434978698635"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      overall schema
    </p>
  </body>
</html>

</richcontent>
<node TEXT="config" ID="ID_1017108248" CREATED="1434978389548" MODIFIED="1434978450257">
<node TEXT="schema{}" ID="ID_601851070" CREATED="1434978410371" MODIFIED="1434978423130"/>
</node>
</node>
<node TEXT="watch[]" ID="ID_1391574594" CREATED="1434954544043" MODIFIED="1434978660044"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      sources to watch
    </p>
  </body>
</html>

</richcontent>
<node TEXT="uri" ID="ID_1257943804" CREATED="1434978577738" MODIFIED="1434978607903"/>
<node TEXT="path" ID="ID_1804733" CREATED="1434978574946" MODIFIED="1434978577133"/>
<node TEXT="watcher" ID="ID_689367655" CREATED="1434978641977" MODIFIED="1434978644564"/>
</node>
<node TEXT="data{}" ID="ID_907808323" CREATED="1434954530850" MODIFIED="1434978719516"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      overall contents
    </p>
  </body>
</html>

</richcontent>
<node TEXT="&lt;config&gt;" ID="ID_797325841" CREATED="1434954563539" MODIFIED="1434954571866">
<node TEXT="&lt;struct&gt;" ID="ID_175661882" CREATED="1434954882380" MODIFIED="1434954885451"/>
</node>
</node>
<node TEXT="meta{}" ID="ID_1680589828" CREATED="1434954693377" MODIFIED="1434980022830"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      uris of origin data
    </p>
  </body>
</html>

</richcontent>
<node TEXT="&lt;config&gt;" ID="ID_80273812" CREATED="1434954636880" MODIFIED="1434954642657">
<node TEXT="&lt;struct&gt;" ID="ID_1459780802" CREATED="1434954887965" MODIFIED="1434954890465">
<node TEXT="_origin" ID="ID_1485476089" CREATED="1434980044073" MODIFIED="1434980151111"/>
<node TEXT="_lastupdate" ID="ID_172827928" CREATED="1434980204727" MODIFIED="1434980229875"/>
<node TEXT="_events" ID="ID_386178395" CREATED="1434980049530" MODIFIED="1434980147677"/>
</node>
</node>
</node>
</node>
<node TEXT="methods" POSITION="left" ID="ID_858223804" CREATED="1434971749831" MODIFIED="1434971762505">
<edge COLOR="#ff6600"/>
<node TEXT="setup" ID="ID_308376703" CREATED="1434972100145" MODIFIED="1434972109476">
<node TEXT="register $appname, $config" ID="ID_1845145242" CREATED="1434971788254" MODIFIED="1434971919880"/>
<node TEXT="search.push/unshift %obj" ID="ID_83998979" CREATED="1434971922428" MODIFIED="1434972024648"/>
<node TEXT="search.push/unshift @list" ID="ID_448365571" CREATED="1434971990483" MODIFIED="1434972019422"/>
<node TEXT="setSchema $config, %schema" ID="ID_449446725" CREATED="1434978358204" MODIFIED="1434978380963"/>
</node>
<node TEXT="load" ID="ID_1517392250" CREATED="1434972124257" MODIFIED="1434972154558">
<node TEXT="load $path" ID="ID_485940925" CREATED="1434979596601" MODIFIED="1434979611368"/>
<node TEXT="load %watch" ID="ID_1070760825" CREATED="1434979616377" MODIFIED="1434979694974"/>
<node TEXT="data" ID="ID_218431727" CREATED="1434972155040" MODIFIED="1434972157301"/>
<node TEXT="source" ID="ID_789552" CREATED="1434972157560" MODIFIED="1434972159422"/>
</node>
<node TEXT="access" ID="ID_424739444" CREATED="1434978336981" MODIFIED="1434978340050">
<node TEXT="get $path" ID="ID_224187396" CREATED="1434979519955" MODIFIED="1434979524448"/>
<node TEXT="get @path" ID="ID_664843750" CREATED="1434979498780" MODIFIED="1434979519455"/>
</node>
</node>
</node>
</map>
