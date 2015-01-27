SightCall Helper
================================================================

SightCall **Helper** is a demonstration web application showcasing
Real-Time Communication for a small online Customer Service center.  It
showcases "Live Text Chat" with an invitation to "Video Chat."
Helper showcases the following features of the SightCall platform.

- Text Chat
- Video Teleconference
- Recording (optional)

### Overview

A Visitor enters the help queue by clicking on a "Video Assistance"
button in a web site.  The Visitor's help window has a text-chat area 
and a video window that can show the video feed of the Agent.

<img src="images/visitor_wait.png" width="200px" />

The Agent console displays a list of tickets waiting to be
serviced.  An Agent may select a specific visitor to help, or may
select the next ticket in queue order.

<img src="images/agent_tickets.png" width="400px" />


SightCall Helper has been created using common web technologies
([Rails](http://rubyonrails.org/),
[Bootstrap](http://getbootstrap.com), [jQuery](http://jquery.com/)),
and is purposely kept small so that it can serve as a starting point
for a complete project.  It is not only a showcase of SightCall
technologies, it is also a tutorial of best-practices and idioms to
use for embedding SightCall features into your own site.

Helper is easy to clone and run on your own servers, or you can try
it out by deploying on Heroku. (Even a free/hobby account will
suffice.) Read on.

## Run It On Heroku

You can run your own instance of SightCall Helper on Heroku in
just a few minutes.

- Clone this repository so you can customize it.
- If you have not already, you must request an API KEY and credentials from SightCall.
  Get it here: [http://www.sightcall.com/developers/](http://www.sightcall.com/developers/).

- Put the files `client.p12` and `authCA.crt` in the `/certs` directory.  Check them in.

```sh
    % cd certs
    % git add client.p12
    % git add authCA.crt
    % git commit -m "add the certs"
    % git push
```

- Unpack your `client.p12` file into its two components.

```sh
    % openssl pkcs12 -in client.p12 -nocerts -out privateKey.pem
    % openssl pkcs12 -in client.p12 -clcerts -nokeys -out publicCert.pem
```

- Check these two files into the `/certs` directory as well.

```sh
    % git add privateKey.pem
    % git add publicCert.pem
    % git commit -m "add the unpacked certs"
    % git push
```


- Create a new Heroku project for this demo.

```sh
    % heroku create
```

Note the URL of the project you just created.  (E.g. https://your-app-1234.herokuapp.com)

- Push the code to Heroku

```sh
    % git push heroku master
```

- Run the `bootstrap` task (in file lib/rake/bootstrap.rb).  This
  creates the database and the default users.  If you would like to
  customize the default users, you can edit the task before you invoke
  it.

```sh
    % heroku run bundle exec rake bootstrap
```

- Set the following Heroku environment variables **exactly** as shown below.

```sh
    % heroku config:set RTCC_CACERT=certs/authCA.crt
    % heroku config:set RTCC_CLIENTCERT=certs/publicCert.pem
    % heroku config:set RTCC_CLIENTCERT_KEY=certs/privateKey.pem
```

- Set the following Heroku environment variables as appropriate for your SightCall account.

```sh
    % heroku config:set RTCC_APP_ID=ab01cd34ef56
    % heroku config:set RTCC_CERTPASSWORD=abcdefgh
    % heroku config:set RTCC_CLIENT_ID=7a7a7a7a7a8b8b8b8b8b9c9c9c9c9c
    % heroku config:set RTCC_CLIENT_SECRET=19ab19ab19ab19ab28cd28cd28cd28
```

Visit the application at your Heroku URL and log-in as one of the
pre-defined Agents.

- agent1 / a1password
- agent2 / a2password
- agent3 / a3password
- agent4 / a4password

On a different computer, have someone else visit the demo page at
https://your-app-1234.herokuapp.com/demo/plain and ask for **Video
Assistance** by clicking the picture of the Video Agent.


## Add the Recording Feature

Contact SightCall if you are interested in Recording video calls.  We
can provide you with a CloudRecorder token.  Once you receive it, add
it to your Helper project this way.

```sh
    % heroku config:set CLOUDRECORDER_TOKEN=xxyyxxyy27331b82ef0e8fa9bfe37fcb
```


## Feature Overview

### Login Page

Agents log in with a username and password.

<img src="images/agent_login.png" width="200px" />


### Select a Ticket

Agents can select a 'ticket' to work on in one of two ways.  They can
select the next available ticket ("Take Next Ticket") or they can
select a particular ticket (by clicking the individual "Take" button).

<img src="images/agent_take.png" width="200px" />


### Interact with a Visitor

An Agent interacts with a Visitor in the "Take" window.  Some items to note.

- the green dot next to "SightCall Helper" means the Agent is connected to the Realtime cloud
- the title "Take eb53d5" identifies the ticket number of the anonymous Visitor
- the "Invite Visitor" button invites the Visitor to Video only after Text Chat has begun
- the Video from the session may be recorded by the CloudRecorder with an optional Title
- the Text Chat area is active as soon as possible
- the Visitor's browser information is available at the bottom of the screen

<img src="images/agent_taketicket1.png" width="200px" />

### List Open Tickets

Agents can list the Open Tickets and see how long each has been
waiting, what Skill they are tagged with and how far along the
Visitor's browser is connecting to the SightCall RealTime platform.

<img src="images/agent_tickets.png" width="200px" />


### List Closed Tickets

Agents can list the Closed Tickets.  The "Progress" column shows the
last operation performed by the Visitor's browser.  An Agent can view
the details of a Ticket by clicking the 'Show' button associated with
each.

<img src="images/closed_index.png" width="200px" />

### Closed Ticket Detail with Recordings

The detail view of a closed ticket displays the Recordings associated
with the Ticket, if there are any.

<img src="images/closed_detail_244.png" width="200px" />


# Demonstration Pages

Demonstration pages mounted at `/demo/plain` and `/demo/lightbox` show
a possible integration of the Helper Visitor page into a fictitious
web site.  For simplicity, the ficitious web site is abstracted to a
single large PNG image with a `<map>` tag for identifying the hot
links of the picture.

The simple Javascript and HTML of the Demonstration pages show how you
might integrate the Visitor side of SightCall Helper into your own
website with just a few lines of code.

### Visitor Plain Style

The Plain demonstration pager style responds to a click in the "Video
Agent" area of the image.

<img src="images/visitor_demoplain.png" width="200px" />

It pops up the Visitor box in a separate window.

<img src="images/visitor_wait.png" width="200px" />


### Visitor Lightbox

The Lightbox demonstration shows how to use
[Colorbox](http://www.jacklmoore.com/colorbox/) to embed the Visitor
window in a layer on top of the web site.  This option takes over the
window of the Visitor, which may be a desirable behavior in some
circumstances.

<img src="images/visitor_lightbox.png" width="200px" />
