// an init script that returns a Map allows explicit setting of global bindings.
def globals = [:]

// defines a sample LifeCycleHook that prints some output to the Gremlin Server console.
// note that the name of the key in the "global" map is unimportant.
globals << [hook : [
        onStartUp: { ctx ->
            ctx.logger.info("Loading the Classic data set into Graph: classic, use TraversalSource: gclassic")
            TinkerFactory.generateClassic(classic)

            ctx.logger.info("Loading the Modern data set into Graph: modern, use TraversalSource: gmodern")
            TinkerFactory.generateModern(modern)

            ctx.logger.info("Loading The Crew data set into Graph: crew, use TraversalSource: gcrew")
            TinkerFactory.generateTheCrew(crew)

            ctx.logger.info("Loading Grateful Dead data set into Graph: grateful, use TraversalSource: ggrateful")
            grateful.io(gryo()).readGraph('data/grateful-dead.kryo')

            ctx.logger.info("Loading Citations data set into Graph: graph from data/citations.kryo, use TraversalSource: g")
            graph.io(GryoIo.build()).readGraph('data/citations.kryo')

            allowSetOfIdManager = { graph, idManagerFieldName ->
                java.lang.reflect.Field idManagerField = graph.class.getDeclaredField(idManagerFieldName)
                idManagerField.setAccessible(true)
                java.lang.reflect.Field modifiersField = java.lang.reflect.Field.class.getDeclaredField("modifiers")
                modifiersField.setAccessible(true)
                modifiersField.setInt(idManagerField, modifiersField.getModifiers() & ~java.lang.reflect.Modifier.FINAL)

                idManagerField.set(graph, TinkerGraph.DefaultIdManager.INTEGER)
            }

            [classic, modern, crew].each{
                allowSetOfIdManager(it, "vertexIdManager")
                allowSetOfIdManager(it, "edgeIdManager")
                allowSetOfIdManager(it, "vertexPropertyIdManager")
            }
        }
] as LifeCycleHook]

// define the default TraversalSource to bind queries to - this one will be named "g".
globals << [g : graph.traversal()]
globals << [gclassic : classic.traversal()]
globals << [gmodern : modern.traversal()]
globals << [gcrew : crew.traversal()]
globals << [ggrateful : grateful.traversal()]