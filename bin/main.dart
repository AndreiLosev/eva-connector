void main(List<String> arguments) {
  final db =
      "postgres://user1:pass1@127.0.0.1:5432/eva-evant-service-db?table=events&unix=false&ssl=false";
  final uri = Uri.parse(db);
  print('Original URL: $uri');
  print('Scheme: ${uri.scheme}'); // https
  print('Authority: ${uri.userInfo}'); // example.com:8080
  print('Host: ${uri.host}'); // example.com
  print('Port: ${uri.port}'); // 8080
  print('Path: ${uri.path}'); // /path/to/resource
  print('Path Segments: ${uri.pathSegments}'); // [path, to, resource]
  print('Query String: ${uri.query}'); // name=John%20Doe&age=30
  print(
    'Query Parameters: ${uri.queryParameters}',
  ); // {name: John Doe, age: 30}
  print('Fragment: ${uri.fragment}'); // section1

  // Example of accessing a specific query parameter
  print('Name parameter: ${uri.queryParameters['name']}');
}
