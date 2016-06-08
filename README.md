# FocoUnlocked
An application that allows users to share their food creations in local cafeterias.

## Purpose & Future Plans
This application was created by three Dartmouth College Computer Science students partnered with the Computer Science Department and the DALI Lab. The students are Madison Minsk, Ijemma Onwuzulike, and Shirley Zhang.

This application was created to allow Dartmouth students to share their creative food combinations at the food court. Students would be able to comment, share, and build an creative and collaborative environment.

Our future plans for this application is to make it open source, so other students and small organizations can grab inspiration from this application. We are hoping to expand this application to other colleges in the area and hopefully to reach out to hospitals to help them with food options within the facilities.

## Design
So far there are only two pages present:
#### The Home Page
    This is where the feed will be seen
    Users will get to scroll down a long feed, similar to Instagram, Twitter, and Tumblr, to see what the latest or the best combination is at the the moment
    The users would have the ability to like (bite) a post, share the post, or report the post
#### The Upload Page
    There are a few things each post needs in order to be submitted to the feed
      - A title
      - A description the same length or longer than the title
      - An image
    Tags are optional, which will be later used for search functionalities

## Implementation
- The Firebase SDK is used for this project
- ArrayList of custom classes are used to hold a large amount of personalized information needed throughout the entire program
- Asynchronous functions are used to collect information from the Firebase database, and send it over the applicaiton
