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

## Details
**Main procedures in namespace \(`::dEx`\)**
- `reset;`  
it resets internal parameters

- `title txt;`  
  it sets title as `$txt`  

- `dRead filePath ?char? ?encoding?;`  
  it reads data from a file
  - `$filePath`: file path of file to load
  - `$char`: split characters; standard white-space characters is default value
  - `$encoding`: encoding name
  
- `count l ?numerical?;`  
  it counts elements in given list and returns a list of element names
  - `$l`: a list
  - `$numerical`: boolean (0|1) indicates if it regards data as numerical data; 0 is default value
  
- `graph elements ?dx? ?min? ?char?;`  
  it makes a graph as ascii art
  - a block is a unit for dealing with data frequency
  - `$elements`: a list of element names that is referred wile using counted array (`$::dEx::V`)
  - `$dx`: a number (`!$dx<1`) that represents a value which is equivalent to a block in a graph; 1 is default value
  - `$min`: the least value (`!$min<0`) to show in a graph; 0 is default value
  - `$char`: a character that is used as a block in a graph; `#` is default value
  
- `output_DATA filePath ?char? ?encoding?;`  
  it outputs raw data list
  - `$filePath`: file path of file to output
  - `$char`: separating characters; tab character is default value
  - `$encoding`: encoding name
  
- `output_FILES filePath ?char? ?encoding?;`  
  it outputs filename list
  - see "`output_DATA`" for parameters
  
- `output_elements filePath ?char? ?encoding?;`  
  it outputs elements list in a counted array
  - see "`output_DATA`" for parameters
  
- `output_table filePath ?char? ?encoding?`  
  it outputs a graph table
  - see "`output_DATA`" for parameters
    
- `log filePath ?encoding?;`  
  it outputs log of the current values as tcl script
  - `$filePath`: file path of file to output
  - `$encoding`: encoding name
  
- `output_GRAPH filePath ?encoding?;`  
  it outputs graph result as ascii art
  - `$filePath`: file path of file to output
  - `$encoding`: encoding name
