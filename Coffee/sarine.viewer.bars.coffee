class SarineBars extends Viewer

	# 'options' includes 'args' from all.json
	constructor: (options) ->
		@resourcesPrefix = options.baseUrl + "atomic/v1/assets/"
		@atomVersion = options.atomVersion

		super(options) # will call convertElement()

		# access stones[0] for its grades
		#@stone = window.stones && window.stones[0]

	# this method replaces <sarine-viewer> with bars html elements
	convertElement :() =>
		@compile = $ """
		<div class="bars_graph_container">

			<!-- this is the placeholder for the generated bars -->
			<div class="graph">
			</div>

			<!-- this is the placeholder for the generated horizontal lines -->
			<div class="grid">
			</div>

			<!-- this is the properties axis -->
			<div class="bars_graph_foot">
			</div>

		</div>
		"""

		@element.append(@compile)

		# return the resulting element
		@element

	first_init : ()->
		console.log("bars: first_init() called")

		$(document).on('createGraph', @createGraph)

		# inject the css file into the DOM
		element = document.createElement("link")
		element.href = @resourcesPrefix + "bars/bars.css?" +  @atomVersion
		element.rel= "stylesheet"
		element.type= "text/css"
		$(document.head).prepend(element)

		defer = $.Deferred()
		defer.resolve(@)
		defer

	full_init : ()->
		console.log("bars: full_init() called")

		defer = $.Deferred()
		defer.resolve(@)
		defer

	play: () -> return

	stop: () -> return

	createGraph: (event, args) ->
		{element, xAxisDivs, grades, yAxisTicks} = args

		console.log("bars: createGraph() called: element: " + element)

		#$(element).find("h1")[0].textContent = grades

		graph = $(".graph", element)

		# for some reason, createGraph event is called more than once per instance....
		# so build the bars only once.
		if graph.find('.bar').length > 0
			return;

		# build the bar DOM elements according to the array
		# and add them into the graph
		for grade in grades
			bar = $("<div class='bar'></div>")
			bar.css({'height': grade + '%'});
			graph.append(bar)

		#normally 'grid' element is placed benith 'graph' element, and is shorter than it.
		#also, the horizontal lines are in the middle (50% in css) of the grade row (30px in css).
		#so make sure the exceptional line has the same height as the top of the exceptional bar in 'graph' and is placed on top of it

		grid = $('.grid', element)

		# build the horizontal-line DOM elements according to the array
		# and add them into the grid
		for tick in yAxisTicks
			line = $("
			<div class='new__row'>
				<div class='new__row__line'></div>
				<div class='new__row__item'>#{tick}</div>
			</div>
			")
			grid.append(line)

		#make the exceptional line has the same height as the top of the exceptional bar
		desiredHeight = graph.height() + 30; # 30 is a single grade row height in css
		grid.height(desiredHeight);

		#make it on it
		desiredTop = -graph.height() - 15; # 15 is half the row size
		grid.css({'margin-top' : desiredTop + 'px'}) 


		# now add the x axis div elements

		foot = $('.bars_graph_foot', element)

		for xAxisDiv in xAxisDivs
			foot.append(xAxisDiv)
		


@SarineBars = SarineBars
