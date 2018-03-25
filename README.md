# gremlin-lang-intro
Docker image for a lightweight Gremlin Server with locally connected Gremlin Console

## Quick Start
Requires [Docker](www.docker.com) to be installed and working. 

Make sure that the APACHE_DOWNLOAD_URL value is set to a viable Apache mirror for your location

To get to a Gremlin Console prompt as quickly as possible, from a Docker command prompt:  

1. Build the Docker image: `docker build -t gremlin-lang-intro .`
2. Start a container from the image: `docker run -it gremlin-lang-intro`

Note that the container contains all of the Gremlin Server YAML files included with the Apache TinkerPop distribution, as well as the ones included in the repository. Any of these can be chosen when the container is run by specifying the `GREMLIN_YAML` environment variable. For example, to start with just the Air Routes data set, run with the following: 

`docker run -e "GREMLIN_YAML=$GREMLIN_SERVER_PATH/conf/gremlin-server-aironly.yaml" -it gremlin-lang-intro ` 

When started, the container will: 

1. Start the Gremlin Server
2. Load one or more data sets
3. Display the Gremlin Server log
4. Start the Gremlin Console
5. Connect the Gremlin Console to the local Gremlin Server

Note that no ports are exposed. This image is designed to be used by a single user from the command line. 

### Some sample commands:
 
Check the remote connection
```groovy
gremlin> :remote
==> Remote - Gremlin Server - [localhost/127.0.0.1:8182]-[dc281dba-e3b9-455a-be71-afdae7e83e46]
```

Check `graph` TinkerGraph variable
```groovy
gremlin> graph
==> tinkergraph[vertices:1491 edges:5324]
```

Check `g` GraphTraversal Source 
```groovy
gremlin> g
==> graphtraversalsource[tinkergraph[vertices:1491 edges:5324], standard]
```

Display count of vertices
```groovy
gremlin> g.V().count()
==> 1491
```

Display count of edges
```groovy
gremlin> g.E().count()
==> 5324

```

### To exit the gremlin console: 

`:x`


### Sample start-up output

```bash
Starting Gremlin Server
Server started 23.
[INFO] GremlinServer - 
         \,,,/
         (o o)
-----oOOo-(3)-oOOo-----

[INFO] GremlinServer - Configuring Gremlin Server from /opt/apache-tinkerpop-gremlin-server-3.3.0-SNAPSHOT//conf/gremlin-server-all.yaml
[INFO] MetricManager - Configured Metrics Slf4jReporter configured with interval=180000ms and loggerName=org.apache.tinkerpop.gremlin.server.Settings$Slf4jReporterMetrics
[INFO] GraphManager - Graph [graph] was successfully configured via [conf/tinkergraph-empty.properties].
[INFO] GraphManager - Graph [classic] was successfully configured via [conf/tinkergraph-empty.properties].
[INFO] GraphManager - Graph [modern] was successfully configured via [conf/tinkergraph-empty.properties].
[INFO] GraphManager - Graph [crew] was successfully configured via [conf/tinkergraph-empty.properties].
[INFO] GraphManager - Graph [grateful] was successfully configured via [conf/tinkergraph-empty.properties].
[INFO] ServerGremlinExecutor - Initialized Gremlin thread pool.  Threads in pool named with pattern gremlin-*
[INFO] ScriptEngines - Loaded gremlin-groovy ScriptEngine
[INFO] GremlinExecutor - Initialized gremlin-groovy ScriptEngine with scripts/generate-all.groovy
[INFO] ServerGremlinExecutor - Initialized GremlinExecutor and configured ScriptEngines.
[INFO] ServerGremlinExecutor - A GraphTraversalSource is now bound to [gclassic] with graphtraversalsource[tinkergraph[vertices:0 edges:0], standard]
[INFO] ServerGremlinExecutor - A GraphTraversalSource is now bound to [gcrew] with graphtraversalsource[tinkergraph[vertices:0 edges:0], standard]
[INFO] ServerGremlinExecutor - A GraphTraversalSource is now bound to [g] with graphtraversalsource[tinkergraph[vertices:0 edges:0], standard]
[INFO] ServerGremlinExecutor - A GraphTraversalSource is now bound to [gmodern] with graphtraversalsource[tinkergraph[vertices:0 edges:0], standard]
[INFO] ServerGremlinExecutor - A GraphTraversalSource is now bound to [ggrateful] with graphtraversalsource[tinkergraph[vertices:0 edges:0], standard]
[INFO] OpLoader - Adding the standard OpProcessor.
[INFO] OpLoader - Adding the control OpProcessor.
[INFO] OpLoader - Adding the session OpProcessor.
[INFO] OpLoader - Adding the traversal OpProcessor.
[INFO] TraversalOpProcessor - Initialized cache for TraversalOpProcessor with size 1000 and expiration time of 600000 ms
[INFO] GremlinServer - Executing start up LifeCycleHook
[INFO] Logger$info - Loading the Classic data set into Graph: [classic]. Use TraversalSource: [gclassic]
[INFO] Logger$info - Loading the Modern data set into Graph: [modern]. Use TraversalSource: [gmodern]
[INFO] Logger$info - Loading The Crew data set into Graph: [crew]. Use TraversalSource: [gcrew]
[INFO] Logger$info - Loading Grateful Dead data set into Graph: [grateful] from data/grateful-dead.kryo. Use TraversalSource: [ggrateful]
[INFO] Logger$info - Loading Citations data set into Graph: [graph] from data/citations.kryo, use TraversalSource: [g]
[INFO] Logger$info -   Adding index on property [name] in Graph: [graph]
[INFO] Logger$info -   Adding index on property [title] in Graph: [graph]
[INFO] AbstractChannelizer - Configured application/vnd.gremlin-v1.0+gryo with org.apache.tinkerpop.gremlin.driver.ser.GryoMessageSerializerV1d0
[INFO] AbstractChannelizer - Configured application/vnd.gremlin-v1.0+gryo-lite with org.apache.tinkerpop.gremlin.driver.ser.GryoLiteMessageSerializerV1d0
[INFO] AbstractChannelizer - Configured application/vnd.gremlin-v1.0+gryo-stringd with org.apache.tinkerpop.gremlin.driver.ser.GryoMessageSerializerV1d0
[INFO] AbstractChannelizer - Configured application/vnd.gremlin-v1.0+json with org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerGremlinV1d0
[INFO] AbstractChannelizer - Configured application/vnd.gremlin-v2.0+json with org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerGremlinV2d0
[INFO] AbstractChannelizer - Configured application/json with org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerV1d0
[INFO] GremlinServer$1 - Gremlin Server configured with worker thread pool of 1, gremlin pool of 1 and boss thread pool of 1.
[INFO] GremlinServer$1 - Channel started at port 8182.
Starting Gremlin Console

INFO: Created user preferences directory.

         \,,,/
         (o o)
-----oOOo-(3)-oOOo-----
plugin activated: tinkerpop.server
plugin activated: tinkerpop.utilities
plugin activated: tinkerpop.tinkergraph
Gremlin Console Init: connecting to local Gremlin Server 
Gremlin Console Init: setting to console mode 
gremlin> 
```

## FAQ
Actually, nobody has yet asked any questions, but I thought that they might wonder about these.

#### Why did you do it this way?
I was giving a Introduction to Gremlin training and wanted the class to hit the ground running.  I didn't want them to mess with data modeling or data loading. They just needed a Gremlin Console into which they could type some traversals. So my main requirements were:
 
1. Have a Gremlin Console command line interface.
2. Have a data set (or sets) already loaded.
3. Any mutations to a graph must be persisted between commands (default Jupyter + Gremlin Console configurations can't do this).
4. Need to be able to restart the Container and get back to a default working configuration with the initial state of the data set.
5. Do not require `:submit` or `:>` to prepend every command, which is usually required when working with a Gremlin Server. 

#### Why do you use binary zip files?
Because I'm lazy, or pressed for time. The ideal solution would be to have a TinkerPop Docker image, and maybe even be able to specify what version of TinkerPop to use. But that isn't available and I don't have an intern (yet) to do it for me. This was created after the release of TinkerPop 3.2.3, but before the release of TinkerPop 3.3. One of the enhancements included in TinkerPop 3.3 is a Gremlin Server init script that supports the usual daemon/service commands: `start|stop|restart|status`. Having that capability made it very simple to write the Dockerfile. I could have used TP 3.2 and backported that script, but then there would have been more to test. Also, I found that the various mirrors don't all offer the same performance, so this had me prefering to include the binary in the repo instead of downloading the zip files from a mirror, or taking a clone and compile approach. Since I was already going to include a binary or two with the Dockerfile, the preferred binaries were the TinkerPop 3.3.0 SNAPSHOT ones.  

#### Why did you use TinkerPop 3.3 SNAPSHOT?
There were some updates in TinkerPop 3.3 to the Gremlin Server init script which I didn't want to back-port to TinkerPop 3.2.3, which was current when I was building this repo.

#### How can I change the data sets that are loaded?
The quick answer is that there the `GREMLIN_YAML` environment variable is set by the Dockerfile. It includes two options, one of which is commented out. 

But more likely you are wanting to add your own data set. Let's say you have "League data" for whatever type of league may interest you, and that is already in a TinkerPop-enabled graph engine. Export that using [Gremlin's IO](http://tinkerpop.apache.org/docs/current/reference/#_gremlin_i_o). Then:
 
1. Add your `league.data` file to the folder with the Dockerfile
2. Create a Groovy script in the folder with the Dockerfile, like `generate-citations.groovy`, which we will call `generate-league.groovy` and set it to read your `league.data` file like in the example.
3. Create a YAML file  in the folder with the Dockerfile like `gremlin-server-citations.yaml`, which we will call `gremlin-server-league.yaml`. In the `scriptEngines.gremlin-groovy.scripts` set the list to include your new script file.  
4. Update the Dockerfile with the following: 
   * Command to add your `league.data` file to the `data` folder:
   
     `COPY league.data /opt/apache-tinkerpop-gremlin-server-3.3.0-SNAPSHOT/data/`
   * Command to add your `generate-league.groovy` file to the `scripts` folder:
    
     `COPY generate-citations.groovy /opt/apache-tinkerpop-gremlin-server-3.3.0-SNAPSHOT/scripts/`
   * Command to add your `gremlin-server-league.yaml` file to the `conf` folder: 
   
     `COPY gremlin-server-league.yaml /opt/apache-tinkerpop-gremlin-server-3.3.0-SNAPSHOT/conf/`
   * Update the `GREMLIN_YAML` environment variable. There should be only one `ENV GREMLIN_YAML` setting in the Dockerfile so you will need to edit or comment out the others: 
    
     `ENV GREMLIN_YAML $GREMLIN_HOME/conf/gremlin-server-league.yaml`
5. Then use the commands in the Quick Start section above to compile the image and start the container. 

#### Why do you run two processess (Gremlin Server & Gremlin Console). Shouldn't you only have one process per Docker container?
Can I just say that the exception proves the rule? Didn't think so. Yes, the ideal configuration in _a properly managed / run production environment_ is one process per container. And if that were my use case, then I would have at least two images, one for a Gremlin Server which exposes the port 8182,and one for the Gremlin Console, or just have the students run the Gremlin Console locally and connect to the Gremlin Server container, or run both the Gremlin Server and Gremlin Console locally, or just run the Gremlin Console locally and have each student load their data. 
  
All of those were possible options but when training large groups the setup needs to be as easy as it can be because one on one technical support for whatever crazy laptop configuration students bring into the course can be very time consuming.
 
So my actual use case is that each student needs to have their own self-contained environment. Also, I don't like having to expose server ports that are really just to be used by one client, internally. The need to be able to load data, possibly multiple data sets, led to needing the Gremlin Server. The need to be able to interact with that data in a reasonably efficient manner led to using the Gremlin Console. My desire for a self-contained environment led to having both in the same image. 


