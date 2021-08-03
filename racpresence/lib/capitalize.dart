String capitalize(String string) {
  if (string.isEmpty) {
    return string;
  }
  var suite = string.substring(1).toLowerCase();
  if (suite.contains(' ')) {
    var tiret = suite.split(' ');
    suite = tiret[0] + ' ' + capitalize(tiret[1]);
  }
  if (suite.contains('-')) {
    var tiret = suite.split('-');
    suite = tiret[0] + '-' + capitalize(tiret[1]);
  }
  if (suite.contains('_')) {
    var tiret = suite.split('_');
    suite = tiret[0] + '_' + capitalize(tiret[1]);
  }
  if (suite.contains("'")) {
    var tiret = suite.split("'");
    suite = tiret[0] + "'" + capitalize(tiret[1]);
  }
  return string[0].toUpperCase() + suite;
}

String capitalizeNom(String string) {
  if (string.isEmpty) {
    return string;
  }
  var tabstring = string.split(" ");
  if (tabstring.length > 2) {
    var nom1 = tabstring[1];
    var nom2 = tabstring[2];

    return capitalize(nom1) + ' ' + capitalize(nom2);
  } else {
    var nom = tabstring[1];
    return capitalize(nom);
  }
}

String capitalizePrenom(String string) {
  if (string.isEmpty) {
    return string;
  }
  var tabstring = string.split(" ");
  var nom = tabstring[0];
  return capitalize(nom);
}

String NomJour(String string) {
  if (string.isEmpty) {
    return string;
  }
  var tabstring = string.split(" ");
  return tabstring[0];
}

String horairepoints(String string) {
  if (string[2] == 'h') {
    var tabstring = string.split("h");
    var retour = tabstring[0] + ':' + tabstring[1];
    return retour;
  } else {
    return string;
  }
}

String convertcourt(var court) {
  var retour = court.toString();
  if (retour.length == 1) {
    retour = '0' + retour;
  }
  return retour;
}
