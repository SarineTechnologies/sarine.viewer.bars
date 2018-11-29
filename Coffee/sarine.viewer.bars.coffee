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

		defer = $.Deferred()
		defer.resolve(@)
		defer

	full_init : ()->
		console.log("bars: full_init() called")

		@showLightBars()

		defer = $.Deferred()
		defer.resolve(@)
		defer

	play: () -> return

	stop: () -> return

	showLightBars: () ->

		grades = [@stone.lightGrades.brilliance.value, @stone.lightGrades.scintillation.value, @stone.lightGrades.fire.value]

		xAxis = [
			"<div class='bars_graph_foot_item' data-popup-id='popup_brilliance'>    \
				<span class='bars_graph_foot_label'>" + lang.lightBars.brilliance + "</span>                      \
				<span class='q-mark-sm'></span>                                     \
			</div>",
			"<div class='bars_graph_foot_item' data-popup-id='popup_sparkle'>       \
				<span class='bars_graph_foot_label'>" + lang.lightBars.scintillation + "</span>                   \
				<span class='q-mark-sm'></span>                                     \
			</div>",
			"<div class='bars_graph_foot_item' data-popup-id='popup_fire'>          \
				<span class='bars_graph_foot_label'>" + lang.lightBars.fire + "</span>                            \
				<span class='q-mark-sm'></span>                                     \
			</div>"
		]

		if @includeSymmetry
			grades.push(@stone.lightGrades.symmetry.value)

			xAxis.push("<div class='bars_graph_foot_item bars_graph_foot_item_four' data-popup-id='popup_symmetry'>       \
				<span class='bars_graph_foot_label'>" + lang.lightBars.symmetry + "</span>                         \
				<span class='q-mark-sm'></span>                                      \
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

		#normally 'grid' element is placed benith 'barsGraph' element, and is shorter than it.
		#also, the horizontal lines are in the middle (50% in css) of the grade row (30px in css).
		#so make sure the exceptional line has the same height as the top of the exceptional bar in 'barsGraph' and is placed on top of it

		#make the exceptional line has the same height as the top of the exceptional bar
		desiredHeight = graph.height() + 30; # 30 is a single grade row height in css
		grid.height(desiredHeight);

		#make it on it
		desiredTop = -graph.height() - 15; # 15 is half the row size
		grid.css({'margin-top' : desiredTop + 'px'}) 


		# now add the x axis div elements

		foot = $('.bars_graph_foot', @element)

		for xAxisDiv in xAxisDivs
			foot.append(xAxisDiv)

		popupService = new PopupService({
        	overlay: document.getElementById('popup_overlay')
        });

		$('.bars_graph_foot_item').click ->
			popupName = this.getAttribute('data-popup-id')
			popupService.open(document.getElementById(popupName))

		$('.popup__close-btn').click ->
			popupService.close(this.parentNode.parentNode)
		
		


@SarineBars = SarineBars
