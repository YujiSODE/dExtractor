# dExtractor
Simple data extraction tool.  
https://github.com/YujiSODE/dExtractor  

>Copyright (c) 2017 Yuji SODE \<yuji.sode@gmail.com\>  
>This software is released under the MIT License.  
>See LICENSE or http://opensource.org/licenses/mit-license.php
______
## Script
It requires Tcl 8.6+.
- Tools: `dExtractor.tcl`
- User interface: `dExtractorUI.tcl`

This program consists of two namespaces: `::dEx` and `::dEx_UI`  
These two files \(`dExtractor.tcl` and `dExtractorUI.tcl`\) should be placed under the same directory.

## Synopsis
`tclsh dExtractorUI.tcl`

## Commands
Any inputs are added into raw data list, excluding command beginning with "@".

- `@help`  
  It shows help.  

- `@exit`  
  It ends this program.  

- `@src filePath`  
  It loads additional Tcl script.  
  - `$filePath`: file path of Tcl script to load  

- `@reset`  
  It resets internal parameters.  

- `@title TITLE`  
  It sets data title.  
  - `$TITLE`: new title name  

- `@read ?filePath? ?char? ?numerical? ?encoding?`  
  It reads a file as sample and updates sample counted data.  
  If all arguments are omitted then it only updates counted data.  
  - `$filePath`: file path to read
  - `$char`: split characters; standard white-space is default setting
  - `$numerical`: boolean (`0|1`) indicates if it regards data as numerical data;  
    `0` is default value
  - `$encoding`: encoding name  

- `@graph ?dx? ?min? ?char?`  
  It makes a graph as ASCII art.  
  A block is a unit for dealing with data frequency  
  - `$dx`: a number \(`!$dx<1`\) that represents a value which is equivalent to a block  
    in a graph;  
    `1` is default value
  - `$min`: the least value \(`!$min<0`\) to show in a graph; `0` is default value
  - `$char`: a character that is used as a block in a graph; "\#" is default value  

- `@title TITLE`  
  It sets data title.  
  - `$TITLE`: new title name  

- `@output_help`  
  It shows a help of output.  

- `@output_DATA filePath ?char? ?encoding?`  
  It outputs raw data list.  
  - `$filePath`: file path of file to output
  - `$char`: separating characters; tab character is default value
  - `$encoding`: encoding name  

- `@output_FILES filePath ?char? ?encoding?`  
  It outputs filename list.  
  - `$filePath`: file path of file to output
  - `$char`: separating characters; tab character is default value
  - `$encoding`: encoding name  

- `@output_elements filePath ?char? ?encoding?`  
  It outputs elements list in a counted array.  
  - `$filePath`: file path of file to output
  - `$char`: separating characters; tab character is default value
  - `$encoding`: encoding name  

- `@output_table filePath ?char? ?encoding?`  
  It outputs a graph table.  
  - `$filePath`: file path of file to output
  - `$char`: separating characters; tab character is default value
  - `$encoding`: encoding name  

- `@output_GRAPH filePath ?encoding?`  
  It outputs graph result as ASCII art.  
  - `$filePath`: file path of file to output
  - `$encoding`: encoding name  

- `@log filePath ?encoding?`  
  It outputs log of the current values as tcl script.  
  - `$filePath`: file path of file to output
  - `$encoding`: encoding name
