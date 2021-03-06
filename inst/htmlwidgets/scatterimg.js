HTMLWidgets.widget({

    name: "scatterimg",
    type: "output",

    initialize: function(el, width, height) {
        d3.select(el).append("svg")
            .attr("width", width)
            .attr("height", height);

        return ({})

    },

    resize: function(el, width, height, instance) {
        // instance.iso.bindResize();
        //instance.iso.reloadItems();
    },

    renderValue: function(el, x, instance) {

        // http://tributary.io/inlet/24effa73749d37af39d6

        var style = x.style;
        var style = "<style> body{overflow:auto !important;}" + style + "</style>";
        d3.select(el).append("div").html(style);

        var svg = d3.select("svg")

        var opts = x.opts;
        var padding = opts.padding;
        // console.log()

        // get the width and height
        // var height = d3.select("svg").attr("height");
        var width = el.offsetWidth;
        var height = el.offsetHeight;


        // Tooltip
        var tooltipOpts = x.tooltipOpts;
        // fixed rectangle to bind tooltip
        legend = svg.append('rect')
            .attr('width', 0)
            .attr('height', 0)
            .attr('x', width / 2)
            .attr('y', 0)
            .attr('class', 'legend')
        var direction = tooltipOpts.direction;
        if (direction == 'fixed') {
            direction = 'se'
        };
        /* Initialize tooltip */
        tip = d3.tip()
            .attr('class', 'd3-tip')
            .html(function(d) {
                return d.tooltip;
            })
            .direction(direction)
            .offset(tooltipOpts.offset);

        /* Invoke the tip in the context of your visualization */
        svg.call(tip)


        // var d = [{
        //     id: "a",
        //     label: "Carlos",
        //     cy: 9,
        //     cx: 100,
        //     radius: 35,
        //     imageUrl: "http://www.randommonkey.io/img/monkey-face-purple.png"
        // }, {
        //     id: "b",
        //     label: "Juan",
        //     cy: 60,
        //     cx: 100,
        //     radius: 35,
        //     imageUrl: "https://dl.dropboxusercontent.com/u/19954023/marvel_force_chart_img/top_spiderman.png"
        // }, {
        //     id: "c",
        //     label: "Yo",
        //     cy: 79,
        //     cx: 100,
        //     radius: 35,
        //     imageUrl: "http://www.randommonkey.io/img/monkey-face-purple.png"
        // }, {
        //     id: "d",
        //     label: "Todos",
        //     cy: 100,
        //     cx: 100,
        //     radius: 35,
        //     imageUrl: "http://www.randommonkey.io/img/monkey-face-purple.png"
        // }];

        var d = HTMLWidgets.dataframeToD3(x.data);
        console.log(d)

        var min = d3.min(d, function(d) {
            return d.cy;
        });
        var max = d3.max(d, function(d) {
            return d.cy;
        });

        var yScale = d3.scale.linear().domain([min, max])
            .range([padding, height - padding]);


        var circleGroup = svg.append("g");


        circleGroup.selectAll("circle")
            .data(d)
            .enter()
            .append('g')
            .append('defs')
            .append('pattern')
            .attr('id', function(d) {
                return (d.id);
            })
            .attr('width', 1)
            .attr('height', 1)
            .attr('patternContentUnits', 'objectBoundingBox')
            .append("svg:image")
            .attr("xlink:xlink:href", function(d) {
                return (d.imageUrl);
            })
            .attr("height", 1)
            .attr("width", 1)
            .attr("preserveAspectRatio", "xMidYMid slice")


        var circles = circleGroup.selectAll("circle")
            .data(d)
            .enter()
            .append("circle")
            .on('mouseout', function(d) {
                if (["circle", "circleLabel"].indexOf(tooltipOpts.element) < 0) {
                    return null
                }
                tip.hide(d)
            })
            .on('mouseover', function(d) {
                if (["circle", "circleLabel"].indexOf(tooltipOpts.element) < 0) {
                    return null
                }
                if (tooltipOpts.direction == 'fixed') {
                    return tip.show(d, legend.node());
                }
                tip.show(d)
            })
            // .on('click', function(d) {
            //     tip.hide(d).show(d)
            // })
            ;

        var circleAttributes = circles
            .attr("cx", function(d) {
                return d.cx;
            })
            .attr("cy", function(d) {
                return yScale(d.cy);
            })
            .attr("r", function(d) {
                return d.radius;
            })
            .attr('id', function(d) {
                return d.id + "Circle"
            })
            .style("fill", function(d) {
                // return "url(#" + d.id + ")" // Changed to dynamic load base url because of shinyapps deployment issue.
                return "url(" + location.href + "#" + d.id + ")"
            });


        var labels = svg.selectAll("text")
            .data(d)
            .enter()
            .append("text")
            .text(function(d) {
                return d.label;
            })
            .attr("x", function(d) {
                return d.cx + d.radius + 10;
            })
            .attr("y", function(d) {
                return yScale(d.cy) + 5;
            })
            .attr("class", "labels")
            .attr('id', function(d) {
                return d.id + "Label"
            })
            .on('mouseout', function(d) {
                if (["label", "circleLabel"].indexOf(tooltipOpts.element) < 0) {
                    return null
                }
                tip.hide(d)
            })
            .on('mouseover', function(d) {
                if (["label", "circleLabel"].indexOf(tooltipOpts.element) < 0) {
                    return null
                }
                if (tooltipOpts.direction == 'fixed') {
                    return tip.show(d, legend.node());
                }
                tip.show(d)
            })
            // .on('click', function(d) {
            //     tip.hide(d).show(d)
            // })
            ;


        var yAxis = d3.svg.axis()
            .scale(yScale)
            .orient("left")
            .ticks(5);

        svg.append("g")
            .attr("class", "axis")
            .attr("transform", "translate(" + padding + ",0)")
            .call(yAxis)




    },
});
