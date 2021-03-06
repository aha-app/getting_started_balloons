# Getting Started Balloons

## Description

Display a balloon on a page to help users get started with an application.
Balloons can be manually positioned and will draw a pretty curved arrow 
(using SVG) between the balloon and the element that you want to describe.

The balloon-plus-arrow technique allows the balloons to be positioned so they
don't obscure some other important element on the page.

![Example](/screenshot.png "Example balloon")

## Prerequisites

JQuery plugin designed to be used with Ruby on Rails applications. The use
of SVG means it will only work in recent browser versions: Firefox, Chrome,
Safari, IE9 & IE10.

## Installation

Add the gem to your Gemfile:

    gem 'getting_started_balloons'

Load the Javascript by adding it to your application.js:

    //= require getting_started_balloons

Load the stylesheet by adding it to your application.css:

    *= require getting_started_balloons

## Usage

A balloon points to a target element. Create the balloon by attaching it
to the target and specifying options:

    $("#save_button").gettingStartedBalloon({
      content: "<b>Note</b> click this button to save your work"
    });
    
The following options are accepted:

### content

    content: "This appears in the balloon"

The content of the balloon - can contain HTML. i.e. it is up to you to 
properly escape this content if necesary.

### width

    width: 300
    
By default the balloon will be 250 pixels wide and will grow vertically. 

### offset    

    offset: 60

Offset that the balloon should be placed from the target element. This offset 
is measured between the bounding boxes of the balloon and the target element.

### angle

    angle: 45

Angle in degrees, measured clockwise from three o'clock, that the balloon should
be placed relative to the target element.

### close

    close: function(element) {
      console.log("Closed balloon")
    }

Callback which will be called when the balloon closes. The target element is passed
to the callback.

### flipLine

    flipLine: true
    
Whether the kink in the line should face the other way.

### targetInset, balloonInset

    targetInset: 0.9,
    balloonInset: 0.8
    
How far the arrow should overlap each element, as a percentage of the element.

### zIndex

    zIndex: 5

The z-index to set on the balloon, useful if the target element is located near other elements with high z-indices that may eclipse the balloon. If not manually set, the z-index is set to 1 higher than that of the target element.

## Credits

Written by Chris Waters (@k1w1) for [Aha! - www.aha.io](http://www.aha.io).
