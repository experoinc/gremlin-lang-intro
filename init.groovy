println "Gremlin Console Init: connecting to local Gremlin Server using session connection"
:remote connect tinkerpop.server conf/remote.yaml session
println "Gremlin Console Init: setting to console mode "
:remote console
