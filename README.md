# Server Administration Menu
Server Administration Menu (SAM) is a bash shellscript and a framework for creating interactive menus to run repetitive tasks on Linux and macOS systems.
![SAM](https://raw.githubusercontent.com/dmitriypavlov/SAM/master/sam.png)

### Features
* online update from GitHub
* default menu download
* simple task expansion
* task confirmation
* unexpected exit prevention
* autostart and **sam** alias in bash profile

### Customization
SAM can be expanded with custom bash functions in **sam.inc** (downloaded automatically if not found):

`sam_ID() {
	samConfirm && echo "Hello, world"
}`

where **ID** is a unique number which triggers particular function start when selected in menu prompt. 

### Installation
**Linux**
`wget -q https://raw.githubusercontent.com/dmitriypavlov/SAM/master/sam.sh && bash ./sam.sh`

**macOS**
`curl -s -O https://raw.githubusercontent.com/dmitriypavlov/SAM/master/sam.sh && bash ./sam.sh`