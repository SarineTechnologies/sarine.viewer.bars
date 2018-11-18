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
		#@compile = $ "<h1>HELLO</h1>"
		#@element.append(@compile)
		
		# return the resulting element
		#return @element;

		# get the html file
		url = @resourcesPrefix + "bars/bars.html?" +  @atomVersion
	
		$.get url, (innerHtml) =>
			# convert the raw html string into an html DOM element
			@compiled = $(innerHtml)

			# $(".buttons",compiled).remove() if(@element.attr("menu")=="false")
			# $(".stone_number",compiled).remove() if(@element.attr("coordinates")=="false")
			# @element.css {width:"100%", height:"100%"}
			# @element.attr("active","false")
			# compiled.find('canvas').attr({width:@element.width(), height: @element.height()})
			
			# @element is the <sarine-viewer> variable, so replace its content with our html elements
			@element.append(@compiled)
		
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

	play: () ->
		console.log("bars: play() called")

		defer = $.Deferred()
		defer.resolve(@)
		defer

	stop: () ->
		console.log("bars: stop() called")

		defer = $.Deferred()
		defer.resolve(@)
		defer

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

		#now move the graph to the right, so the grade names would be on the left of the graph
		graph.css({'margin-left' : '80px'})

		# now add the x axis div elements

		foot = $('.bars_graph_foot', element)

		for xAxisDiv in xAxisDivs
			foot.append(xAxisDiv)

		#now move the x axis labels to the right, so the labels would be in the center of the bars (see their css rules)
		foot.css({'margin-left' : '80px'})


@SarineBars = SarineBars
