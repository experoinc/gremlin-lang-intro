// an init script that returns a Map allows explicit setting of global bindings.
def globals = [:]

// defines a sample LifeCycleHook that prints some output to the Gremlin Server console.
// note that the name of the key in the "global" map is unimportant.
globals << [hook : [
        onStartUp: { ctx ->
            ctx.logger.info("Loading Air Routes data set into Graph: [graph] from data/air-routes.graphml. Use TraversalSource: [g]")
            graph.io(graphml()).readGraph('data/air-routes.graphml')
        }
] as LifeCycleHook]

// define the default TraversalSource to bind queries to
globals << [g : graph.traversal()]
