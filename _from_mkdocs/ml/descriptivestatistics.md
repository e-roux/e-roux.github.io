# Descriptive statistics

## Basics: mean, median, mode and quantiles

<img style='float:right; width:20%' src='https://upload.wikimedia.org/wikipedia/commons/3/33/Visualisation_mode_median_mean.svg'></img>
The [ **Arithmetic mean** ](https://en.wikipedia.org/wiki/Arithmetic_mean) is the sum of a collection of numbers divided by the count of numbers in the collection

$$\displaystyle {\overline {x}}={\frac {1}{n}}\sum _{i=1}^{n}{x_{i}}$$

The [ **Median** ](https://en.wikipedia.org/wiki/Median) $M_e$ is a value separating the higher half from the lower half of a data sample, a population or a probability distribution.

$$\displaystyle \mathrm {median} (x)={\frac {1}{2}}(x_{\lfloor (n+1)/2\rfloor }+x_{\lceil (n+)/2\rceil })$$

<img align="right" src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Iqr_with_quantile.png/330px-Iqr_with_quantile.png"></img>
The [ **Mode** ](https://fr.wikipedia.org/wiki/Mode_(statistiques)) $M_0$ of a set of data values is the value that appears most often.

[ **Quantiles** ](https://en.wikipedia.org/wiki/Quantile) are cut points dividing the range of a probability distribution into continuous intervals with equal probabilities, or dividing the observations in a sample in the same way.


<div style='clear:both;'></div>


??? example "Application: box-plot"

     Standardized way of displaying the dataset based on a five-number summary:

     **Median (Q2 / 50th percentile)** : the middle value of the dataset.

     **First quartile (Q1 / 25th percentile)** : or lower quartile qn(0.25), is the median of the lower half of the dataset.

     **Third quartile (Q3 / 75th percentile)** : or upper quartile qn(0.75), is the median of the upper half of the dataset.


     **Interquartile range (IQR)** : is the distance between the upper and lower quartiles.

    $$\displaystyle {\text{IQR}}=Q_{3}-Q_{1}=q_{n}(0.75)-q_{n}(0.25)$$

     **Minimum** : the lowest data point with or wo. any outliers.

     **Maximum** : the largest data point with or wo. any outliers.

      > The whiskers can represent several possible alternative values, among them:
      >
      > - the minimum and maximum of all of the data (as in figure 2)
      > - one standard deviation above and below the mean of the data
      > - the 9th percentile and the 91st percentile
      > - the 2nd percentile and the 98th percentile.

    Example with wiskers with maximum 1.5 IQR:

    ![Ex](https://upload.wikimedia.org/wikipedia/commons/1/1a/Boxplot_vs_PDF.svg)


## Moment

The moment of order r ∈ ℕ is a random variable X, an indicator of the spread of this variable.

### Raw, central, normalised moment

$X$ is a random variable and $\mathbb{E}$ the expectation operator. The raw, central and normalised moments are defined if the following exist:

$$\begin{align}
m_{r} & \triangleq {\mathbb {E}}(X^{r}) \\
\mu_r & \triangleq \mathbb{E}([X - \mathbb{E}(X)]^r) \\
\beta_{r-2} & \triangleq \mathbb{E} \left[ \left( \frac{X - \mu}{\sigma} \right )^r \right ]
\end{align}$$

Some moments are commonly used to characterize a random variable $X$:

- the **expected value** aka the mean, moment of first order:

$$\displaystyle \mu \triangleq m_{1}=\mathbb {E} (X)$$

- The second central moment is the **variance**: 

$$\operatorname {V}(X)\triangleq {\mu}_{2}={\mathbb {E}}[(X-\mu )^{2}]$$

The positive square root of the variance is the **standard deviation:** 

$$\displaystyle \sigma \triangleq {\sqrt {\operatorname {V} (X)}}={\sqrt {\mu_{2}}}$$

- The third central moment is the measure of the lopsidedness of the distribution: **Skewness**

$$\displaystyle {\gamma}_{1}\triangleq {\beta}_{1}=\mathbb {E} \left[\left({\frac {X-\mu }{\sigma }}\right)^{3}\right]$$

- The fourth central moment is a measure of the heaviness of the tail of the distribution, compared to the normal distribution of the same variance: **Kurtosis**

$$\displaystyle \beta_{2}=\mathbb {E} \left[\left({\frac {X-\mu }{\sigma }}\right)^{4}\right]$$

