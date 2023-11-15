# CSS


## Element size

!!! width
	```
	[ <length> | <percentage> ] && [ border-box | content-box ]? |
	 available | 
	 min-content | 
	 max-content | 
	 fit-content | 
	 auto
	```


## Flex box

<badge-doc href="https://www.w3.org/TR/css-flexbox-1" label="spec" message="flex" logo="W3C" color="C3C3C3"></badge-doc>


### Initialisation 

`display: flex;` or `  display: inline-flex;`


### Properties that apply to the parent

#### Ordering and Orientation

Property | Value | Comment
-----------|-------------------------------|------
`flex-direction` | **row** \| **row-reverse** \| **column** \| **column-reverse** | *Ex.*: div { flex-direction: row; }<br/><br/> ![F](https://www.w3.org/TR/css-flexbox-1/images/flex-flow1.svg)
`flex-wrap` | **nowrap** \| **wrap** \| **wrap-reverse** | *Ex.*: div { flex-direction: column; flex-wrap: wrap; }<br/><br/> ![F](https://www.w3.org/TR/css-flexbox-1/images/flex-flow2.svg)
`flex-flow` | *see individual properties* | Shorthand for `flex-direction` and `flex-wrap` <br/><br/>*Ex.*: div { felx-flow: row-reverse wrap-reverse; }<br/><br/> ![F](https://www.w3.org/TR/css-flexbox-1/images/flex-flow3.svg)

<div id="flex">
  <div class="item">1</div>
  <div class="item">2</div>
  <div class="item">3</div>
  <div class="item">4</div>
</div>



<div id="grid">
  <div class="itemg">1</div>
  <div class="itemg">2</div>
  <div class="itemg">3</div>
  <div class="itemg">4</div>
</div>



!!! Ordering and Orientation

	- `justify-content`
	- `align-items`
	- `align-content`

	Property | Value | Comment
	-----------|-------------------------------|---
	`justify-content` | **flex-start** \| **flex-end** \| **center** \| **space-between** \| **space-around** |
	`align-items` | **flex-start** \| **flex-end** \| **center** \| **baseline** \| **stretch** |
	`align-content` | **flex-start** \| **flex-end** \| **center** \| **space-between** \| **space-around** \| **stretch**   |



### Properties that apply to the child elements

!!! Ordering and Orientation

	- `order `: flex flow direction

	Property | Value
	-----------|-------------------------------
	`order`  | *<integer\>*



!!! Flexibility

	Property | Value
	-----------|-------------------------------
	`flex-grow`  | *<number\>*
	`flex-shrink`  | *<number\>*
	`flex-basis	`  | *content* \| *<width\>*

