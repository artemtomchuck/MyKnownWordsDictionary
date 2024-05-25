# MyKnownWordsDictionary

# Purpose
Store your dictionary of learned words of foreign language

# Use case
Suppose your native language is Russian and you learn English.

In order to learn/improve your English you want to read some English book (or watch some English film).
But there are a lot of unknown words in this book.

You can start read this book, but you will constantly use translator to search unknown words which are occurred pretty frequently. This constant looking into translator is quite annoying. You can loose interest in reading because you are distracted by unknown words.

With this program you can extract all unknown words from book and translate them.
Program maintains database of your known words. So when you extract words from new book then already known words are filtered out.

As a result of this program you receive csv file with unknown words and their translation.
You can learn these unknown words before actual reading book. And only then read the book.
When you at least once saw this word during preliminary unknown words review then it will be much easier to deal with this word during actual reading book and your experience with reading English book will be improved.

Another way to use this progrma is vice versa.
Suppose you already read some English book with a lot of unknown words, but you want to learn those unknown words from book once again.

Just extract unknown words from book and learn them. It will be easier to learn word when you already saw this word while actual reading book.


# How does it work?
* you provide input text from your book (or subtitles from film) in txt format into input folder
* program will read all text files in input folder. There is no check of files whether it is text file or not (neither content check, nor file extension check). So please provide only files which can be interpeted as text. Program scans the whole input folder including all subfolders (this is in order to conveniently translate subtitles of TV series which are typically grouped into folders by seasons)
* program will extract all words from those txt files and show only unique words within input
* program will compare input words with database of your already known words
* program will translate only unknown words and provide output csv file with translation
* program will modify database of your known words by including here all recently translated words
* program will archive content of your input directory

# Setup and usage
* install PDI into your Windows OS
* install Ubuntu WSL into your Windows OS
* install https://github.com/soimort/translate-shell utility inside your Ubuntu WSL with the following command
<pre>
  $ git clone https://github.com/soimort/translate-shell
  $ cd translate-shell/
  $ make
  $ [sudo] make install
</pre>
* copy content of SourceCode folder into your desired install folder (e.g. into C:\MyKnownWordsDictionary)
* copy Configuration\ConfigurationFile\configuration.properties file into C:\Users\\<username\>\AppData\Roaming\MyKnownWordsDictionary folder (create this folder manually)
* provide your values into this configuration file. Description of each parameter is also available in comments of configuration file
  * set current_dictionary_db_file_fullpath to value where your db is located. DB template can be found in Configuration\DatabaseBootstrap. Copy this db template to your folder where you are going to store current db and all db history. This path should be set into current_dictionary_db_file_fullpath
  * set input_dir_fullpath to folder path where you typically will provide your input files
  * set output_dir_fullpath to folder path where translated output for new words is stored
  * set source_language to language of your source text in input folder
  * set target_language to language of your translated text in output folder
* another possibility is to provide path to configuration path via parameter configuration_file_fullpath
  * this gives possibility to support one configuration file per each translation pair (e.g. English->Russian, German->Russian etc)
  * example of configuration_file_fullpath usage can be found in C:\MyKnownWordsDictionary\entry_point.cmd.template. You can create entry_point for each config (translation pair) you use
  * if configuration_file_fullpath is not provided then default value is used "C:\Users\\<username\>\AppData\Roaming\MyKnownWordsDictionary\configuration.properties"
* after providing all necessary parameters into configuration file and providing input files run the program by either
  * run file C:\MyKnownWordsDictionary\entry_point.cmd.template
  * or via executing job jb_entry_point.kjb in PDI Spoon (or in PDI kitchen)
* check results in output_dir_fullpath folder (concrete folder location is defined in your configuration file)
* you can also see execution logs in C:\Users\\<username\>\AppData\Local\MyKnownWordsDictionary\logs folder. Each program run creates new log file with respective timestamp. If something works unexpectedly then it is the first place to check
* processed input is archived into C:\Users\\<username\>\AppData\Local\MyKnownWordsDictionary\archive\source_language\\<your_source_language\> folder. Each program run creates new archive file with respective timestamp
* once this mechanism is configured, the next run will require only providing new input files and runnning entry point

# Output
Output of this program is csv file (YYYYYMMDD_HHMMSS_unknown_words_to_learn.csv) with the following structure: original_word, translation.
You can use this output file in the way you prefer.
But author of this project found already existing Android application quite useful for viewing output csv file.

Here is application https://play.google.com/store/apps/details?id=flashcards.words.words or on their site https://flashcards.world/

You can import output csv into this Flashcards Android application and conveniently learn new words.
Flashcards will store your progress of learning within each csv-file. While MyKnownWordsDictionary (this project) will maintain your global database of all learned words.

For overview in Flashcards it is conveniently to use 'Basic overview' mode with hidden original_word. You will see only translation column in such case, but author included into translation column also original word so original word and translation can be viewed together in one cell (it is convenient for Flashcards application). In order to mark word as learned just press 'Easy' button in Flashcards application (while learning word in 'Basic overview' mode).


# Dependencies
* OS Windows. Tested with the following version:
<pre>
    Release  Windows 10 Pro
    Version  21H2
    Build    19044.1826
    Windows Feature Experience Pack 120.2212.4180.0
</pre>
* PDI (Pentahoo Data Integration). Tested with community edition version 9.3.0.0-428
  * PDI also requires JDK. When choosing JDK for installation, consider compatibilty. E.g. for PDI version 9.3 check compatibility table in https://help.hitachivantara.com/Documentation/Pentaho/9.3/Setup/Components_Reference#r_pentaho_java_virtual_machine_comp_ref
* SQLite db. Tested with the 3.36.0 version of SQLite. SQLite version is checked with "SELECT sqlite_version()" in template db. Template db can be found in Configuration\DatabaseBootstrap
* Ubuntu WSL (Ubuntu terminal which is built into Windows OS)
  * WSL version is probably defined by OS Windows version
  * Tested with 20.04 LTS Ubuntu version
* https://github.com/soimort/translate-shell utility which should be installed in Ubuntu WSL

# Troubleshooting
* it may appear that Ubuntu WSL cannot reach Internet (particularly DNS was blocked because ping didn't resolve hostname, but ping by IP address directly worked). Without internet in Ubuntu WSL you cannot translate words with translate-shell utility. In such case check your firewall in Windows (e.g. in author's case Avast trial premium antivirus blocked access to Ubuntu WSL. Either set firewall in Avast premium antivirus properly or downgrade to Avast Free antivirus where there is no such problem)
* if Spoon call in entry_point.cmd initializes long time due to some startup delays in "karaf" (this some internal PDI dependency) then double check that your JDK version is correctly choosen. In author case the issue was in using jdk-18 which is not yet compatible with PDI 9.3. So after switching PDI 9.3. to use certified jdk-11.0.13 the issue disappeared. If you have multiple JDK installed in computer then let PDI know which version it should use with environment variable PENTAHO_JAVA_HOME. E.g. in author case set PENTAHO_JAVA_HOME="C:\Program Files\Java\jdk-11.0.13"
* if there is some encoding issues in your translated text then try to add "-Dfile.encoding=utf8" into PENTAHO_DI_JAVA_OPTIONS section of Spoon.bat in your PDI installation (e.g. in C:\pdi-ce-9.3.0.0-428\data-integration\Spoon.bat). Source of solution: https://forums.pentaho.com/threads/94865-encoding-problem-utf8

# Notes
* current version of project is written for Windows (it was enough for author). But with a little change it can be adjusted for usage in Linux (e.g. add some logic to avoid using Windows environment variables in case OS is Linux)
* translation performance: approximately 5000 words per hour. Translation step is the main bottleneck of this program because it uses command line call to external translation utility for each word. This performance was good enough for author of project.
* the only reason for using Ubuntu WSL: I haven't found convenient and free way to translate words inside Windows OS. But I found a way to do this in Linux terminal with https://github.com/soimort/translate-shell utility. Therefore we use Linux termninal (Ubuntu WSL in current case) only in order to use translate-shell utility. This is very convenient and free utility to translate words from Linux command line (and it does not work from Windows)
* this is not needed if you only plan to use project as is without further development. But if you plan to develop this project then please configure shared connection string for your PDI environment. More details you can find in comments of Configuration\Connection\shared.xml file. Or alternatively you can open some existing transformation which uses connection string and push "Share" on this connection string. This action will make sure that you can reuse already existing connection string and you don't need to add connection string for each new transformation. Again - this is needed only for development because for simple running of existing transformation all needed information regarding connection string is already built into existing transformations. We cannot extract connection string information from transformations (because it is the way PDI stores connections in transformations), but we can isolate into connection string variables all sensitive information so this sensitive information will not be copypasted in every transformation








