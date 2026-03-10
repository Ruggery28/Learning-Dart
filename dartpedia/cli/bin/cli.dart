import 'dart:io';
import 'package:http/http.dart' as http;

const version = '0.0.1';

void main(List<String> arguments) {
  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();
  } else if (arguments.first == 'search') {
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
    searchWikipedia(inputArgs);
  } else {
    printUsage();
  }
}

// Catch-all for any unrecognized command.
void printUsage() {
  print(
    "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'",
  );
}

void searchWikipedia(List<String>? arguments) async{
  // ? after List<String> means that the arguments can be null.
  final String articleTitle;

  // If the user didn't pass in arguments, request an article title.
  if (arguments == null || arguments.isEmpty) {
    print('Please provide an article title.');
    // Await input and provide a default empty string if the input is null.
    final inputFromStdin = stdin.readLineSync();
    if(inputFromStdin == null || inputFromStdin.isEmpty){
      print("No article title provided. Exiting");
      return;
    }
    articleTitle = inputFromStdin;
  } else {
    // Otherwise, join the arguments into a single string.
    articleTitle = arguments.join(' ');
  }
  print("Looking up articles about '$articleTitle' .Please wait");
  var articleContent = await getWikipediaArticle(articleTitle);
  print(articleContent);
}

//Method to search a article on wikipedia
Future<String> getWikipediaArticle(String articleTitle) async{
  final url = Uri.https(
    "en.wekipedia.org", //http link
    "/api/rest_v1/page/summary/$articleTitle" ,//API path
  );
  final response = await http.get(url); //this send the hhtp request and waits for the server to respond. The response is stored in the variable response.
  if(response.statusCode == 200){ //200 means that the request was successful and the server returned the requested data. If the status code is 200, we can access the content of the article through response.body, which contains the body of the HTTP response as a string.
    return response.body;
  } 

  return "Error: Failed to fecth article: $articleTitle .Status code: ${response.statusCode}";
}