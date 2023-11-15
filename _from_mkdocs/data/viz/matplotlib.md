# Matplotlib

<img src='https://matplotlib.org/_static/logo2_compressed.svg' class='titleLogo' alt='logo'/>

verything in matplotlib is organized in a hierarchy:

- at the top of the hierarchy is the matplotlib "state-machine environment" which is provided by the matplotlib.pyplot module. At this level, simple functions are used to add plot elements (lines, images, text, etc.) to the current axes in the current figure.

![Artist hierarchy](https://thepracticaldev.s3.amazonaws.com/i/la33f9zwg65hqjz9j4ee.png)

https://dev.to/skotaro/artist-in-matplotlib---something-i-wanted-to-know-before-spending-tremendous-hours-on-googling-how-tos--31oo

## Anatomy of a figure

![Anatomy](https://matplotlib.org/_images/anatomy.png)

https://matplotlib.org/tutorials/intermediate/artists.html

## Axis

Accessor method       |Description												
----------------------|---------------------------------------------------------
`get_scale`             |The scale of the axis, e.g., 'log' or 'linear'
`get_view_interval`     |The interval instance of the axis view limits
`get_data_interval`     |The interval instance of the axis data limits
`get_gridlines`         |A list of grid lines for the Axis
`get_label`             |The axis label - a Text instance
`get_ticklabels`        |A list of Text instances - keyword minor-True|False
`get_ticklines`         |A list of Line2D instances - keyword minor-True|False
`get_ticklocs`          |A list of Tick locations - keyword minor-True|False
`get_major_locator`     |The matplotlib.ticker.Locator instance for major ticks
`get_major_formatter`   |The matplotlib.ticker.Formatter instance for major ticks
`get_minor_locator`     |The matplotlib.ticker.Locator instance for minor ticks
`get_minor_formatter`   |The matplotlib.ticker.Formatter instance for minor ticks
`get_major_ticks`       |A list of Tick instances for major ticks
`get_minor_ticks`       |A list of Tick instances for minor ticks
`grid`                  |Turn the grid on or off for the major or minor ticks


## Spines

