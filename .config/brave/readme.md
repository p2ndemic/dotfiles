#### Config location:
```cp ./brave-flags.conf ~/.config/```

#### Policies location:  
- https://support.brave.com/hc/en-us/articles/360039248271-Group-Policy  
- https://github.com/MulesGaming/brave-debloatinator/wiki/Additional-Resources#other-tools

```
mkdir -p /etc/brave/policies/managed/
cp ./policies.json /etc/brave/policies/managed/
```

#### Adblock Lists [choose one]:  
```https://big.oisd.nl```  
```https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/pro.plus.txt```

### Other flags  
_--### Vulkan ###--_  
```--use-vulkan=native```  

_--### UseOzonePlatform ###--_  
```--enable-features=UseOzonePlatform```

_--### ChromeOSDirectVideoDecoder ###--_  
```--enable-features==UseChromeOSDirectVideoDecoder```  
```--disable-features=UseChromeOSDirectVideoDecoder```

_--### Disable prerender from omnibox ###--_  
```--prerender-from-omnibox=disabled```

_--### Attempts to run a page's unload event handler independent of the main browser thread, potentially speeding up tab closing. ###--_
```--enable-fast-unload```

_--### Enable Async Dns [unstable] ###--_  
```--enable-async-dns```

```--num-raster-threads=4```
```--use-cmd-decoder=passthrough```

_--### Enable Raw-draw [unstable] ###--_ 
```--enable-raw-draw```
