# CompileCSDocker
Tired of booting your whole Windows VM just to compile that one tool ?
Just run `csb YourTool` from Linux with any of the ones listed below.

_Your favourite tool is missing ?_ Just run `csb https://git/YourFavouriteTool.git`, if it compiles then contributions are welcome

Example run : 

![image](https://github.com/dreamkinn/CompileCSDocker/assets/55366132/6bfc45b1-5b99-4b18-a59c-a5eb5f12ec69)

## Build and Installation
Choose if you want to build for docker or podman
### Docker build
```
# Docker
ln -s entrypoint_docker.sh entrypoint.sh
docker build -t csbuild . 
```

### Podman build
```
# Podman
ln -s entrypoint_podman.sh entrypoint.sh
podman pull docker.io/library/mono
podman build . -t csbuild
```

You can set an alias in your .bashrc
```
alias csb="docker run -it -v $(pwd):/data --rm csbuild"
```
## Usage
```
# With alias
csb SharpHound
# or
csb "https://github.com/BloodHoundAD/SharpHound"

# Without alias
docker run -it -v $(pwd):/data --rm csbuild "https://github.com/BloodHoundAD/SharpHound"
```
Some other tools are available in `-l` but don't compile out-of-the-box.
The initial tools list comes from @Aetsu's nice project OffensivePipeline : https://github.com/Aetsu/OffensivePipeline
## Compiling Out-of-the-box
```
ADCollector
ADCSPwn
ADFSDump
ADSearch
BadPotato
BetterSafetyKatz
DeployPrinterNightmare
ForgeCert
Internal-Monologue
LockLess
MinidumpParser
NativeDump
RDPThiefInject
RunasCS
SafetyKatz
SauronEye
SharpAppLocker
SharpBypassUAC
SharpChisel
SharpChisel
SharpChromium
SharpCloud
SharpCOM
SharpCrashEventLog
SharpDir
SharpDump
SharpEDRChecker
SharpEfsPotato
SharpExec
SharpHandler
SharpHound
SharpImpersonation
SharpKatz
SharpLAPS
SharpMiniDump
SharpNamedPipePTH
SharpNoPSExec
SharpPrinter
SharpProcessDump
SharpReg
SharpScribbles
SharpSearch
SharpSecDump
SharpShares
Sharp-SMBExec
SharpSQLPwn
SharpSvc
SharpTask
SharpUnhooker
SharpUp
SharpVeeamDecryptor
SharpWebServer
SharpWifiGrabber
SharpWMI
Shhmon
SqlClient
SweetPotato
ThreatCheck
TokenStomp
TruffleSnout
Watson
WMIReg
```
