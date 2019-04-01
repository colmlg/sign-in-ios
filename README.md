# sign-in-ios
This is the iOS application portion of my final year project.  
It is an app that students use to mark their attendance at lectures, written in Swift.  

Room numbers are broadcast over bluetooth by a Raspberry Pi acting as a bluetooth beacon.  
The app uses this to determine what room the student is in.  
When the student marks their attendance at a class, they are asked to take a picture of their face to confirm their identity.  
This is compared with a reference image stored on the backend and if the two images match they are marked as having attended the class.  

If users sign up using their University of Limerick ID number their timetable will be scraped from the UL timetable automatically.  

![App Screenshots](https://i.imgur.com/rktwvkU.png)


## To Run
Ensure the [bluetooth beacon](https://github.com/colmlg/fyp-raspberry-pi-script) is broadcasting a room number.  
Open the workspace in XCode and build the project.  


Edit `Network/BaseAPIService.baseUrl` to change the address of the backend server.


If you are running the backend locally it is useful to use [ngrok](https://ngrok.com/) command line tool to create a tunnel to your localhost.
To use it, first start the [backend server](https://github.com/colmlg/sign-in-backend) locally and then from the command line run `ngrok http 3000`.  
This will provide you with a public URL (e.g. http://0fd1b701.ngrok.io) that you can then paste into BaseAPIService.
