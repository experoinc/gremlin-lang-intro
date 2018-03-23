// an init script that returns a Map allows explicit setting of global bindings.
def globals = [:]

// defines a sample LifeCycleHook that prints some output to the Gremlin Server console.
// note that the name of the key in the "global" map is unimportant.
globals << [hook : [
        onStartUp: { ctx ->
            ctx.logger.info("Loading Citations data set into Graph: [graph] from data/citations.kryo. Use TraversalSource: [g]")
            ctx.logger.info("  Adding index on property [name] in Graph [graph]")
            graph.createIndex("name",Vertex.class)
            ctx.logger.info("  Adding index on property [title] in Graph [graph]")
            graph.createIndex("title", Vertex.class)
            graph.io(GryoIo.build()).readGraph('data/citations.kryo')
        }
] as LifeCycleHook]

// define the default TraversalSource to bind queries to - this one will be named "g".
globals << [g : graph.traversal()]
