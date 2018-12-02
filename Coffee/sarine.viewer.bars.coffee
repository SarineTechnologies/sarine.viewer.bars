class SarineBars extends Viewer

	
	constructor: (options) ->
		@resourcesPrefix = options.baseUrl + "atomic/v1/assets/"
		@atomVersion = options.atomVersion

		#access all objects on 'window' and 'document'
		@stone = window.stones && window.stones[0]

		@isStoneRound = @stone && @stone.stoneProperties && /(round)/ig.test(@stone.stoneProperties.shape);

		# 'options' includes 'args' from all.json
		@includeSymmetry = options.includeSymmetry && @isStoneRound;

		super(options) # will call convertElement()


	# this method replaces <sarine-viewer> with bars html elements
	convertElement :() =>
		@compile = $ """
		<div class="bars_graph_container">

			<!-- this is the placeholder for the generated bars -->
			<div class="barsGraph">
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

		# inject the css file into the DOM
		element = document.createElement("link")
		element.href = @resourcesPrefix + "bars/bars.css?" +  @atomVersion
		element.rel= "stylesheet"
		element.type= "text/css"
		$(document.head).prepend(element)

		# create the graph here on first_init() and NOT in full_init() so that the popup (of the ?) would work on the bases
		# since bases' main() is called after all atoms' first_init()
		@showLightBars()

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

	showLightBars: () ->

		grades = [@stone.lightGrades.brilliance.value, @stone.lightGrades.scintillation.value, @stone.lightGrades.fire.value]

		xAxis = [
			"<div class='bars_graph_foot_item' data-popup-id='popup_brilliance'>    \
				<div class='bars_graph_foot_label'>" + lang.lightBars.brilliance + "</div>                      \
				<div class='q-mark-sm'></div>                                     \
			</div>",
			"<div class='bars_graph_foot_item' data-popup-id='popup_sparkle'>       \
				<div class='bars_graph_foot_label'>" + lang.lightBars.scintillation + "</div>                   \
				<div class='q-mark-sm'></div>                                     \
			</div>",
			"<div class='bars_graph_foot_item' data-popup-id='popup_fire'>          \
				<div class='bars_graph_foot_label'>" + lang.lightBars.fire + "</div>                            \
				<div class='q-mark-sm'></div>                                     \
			</div>"
		]

		if @includeSymmetry
			grades.push(@stone.lightGrades.symmetry.value)

			xAxis.push("<div class='bars_graph_foot_item' data-popup-id='popup_symmetry'>       \
				<div class='bars_graph_foot_label'>" + lang.lightBars.symmetry + "</div>                         \
				<div class='q-mark-sm'></div>                                      \
			</div>"
			)

		yAxisLabels = [
			lang.lightBars.Exceptional,
			lang.lightBars.veryHigh,
			lang.lightBars.High,
			lang.lightBars.Standard,
			lang.lightBars.Minimum,
			'' # this is the x axis itself
		]

		#grade of 5 is 100% since its the maximum
		grades = grades.map (g) ->  g * 20 
		
		@createGraph(xAxis, grades, yAxisLabels);


	createGraph: (xAxisDivs, grades, yAxisTicks) ->

		console.log("bars: createGraph() called. element: " + @element)

		#$(@element).find("h1")[0].textContent = grades

		graph = $(".barsGraph", @element)

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

		grid = $('.grid', @element)

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

		# now add the x axis div elements

		foot = $('.bars_graph_foot', @element)

		for xAxisDiv in xAxisDivs
			foot.append(xAxisDiv)

		


@SarineBars = SarineBars
