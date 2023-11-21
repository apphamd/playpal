import 'package:flutter/material.dart';

class USStates {
  static final List<DropdownMenuItem<dynamic>> statesList =
      State.values.map((e) => DropdownMenuItem(child: Text(e.code))).toList();
}

enum State {
  al('Alabama', 'AL'),
  ak('Alaska', 'AK'),
  az('Arizona', 'AZ'),
  ar('Arkansas', 'AR'),
  ca('California', 'CA'),
  co('Colorado', 'CO'),
  ct('Connecticut', 'CT'),
  de('Delaware', 'DE'),
  fl('Florida', 'FL'),
  ga('Georgia', 'GA'),
  hi('Hawaii', 'HI'),
  id('Idaho', 'ID'),
  il('Illinois', 'IL'),
  ind('Indiana', 'IN'), // in is a keyword, so we use ind here instead
  ia('Iowa', 'IA'),
  ks('Kansas', 'KS'),
  ky('Kentucky', 'KY'),
  la('Louisiana', 'LA'),
  me('Maine', 'ME'),
  md('Maryland', 'MD'),
  ma('Massachusetts', 'MA'),
  mi('Michigan', 'MI'),
  mn('Minnesota', 'MN'),
  ms('Mississippi', 'MS'),
  mo('Missouri', 'MO'),
  mt('Montana', 'MT'),
  ne('Nebraska', 'NE'),
  nv('Nevada', 'NV'),
  nh('New Hampshire', 'NH'),
  nj('New Jersey', 'NJ'),
  nm('New Mexico', 'NM'),
  ny('New York', 'NY'),
  nc('North Carolina', 'NC'),
  nd('North Dakota', 'ND'),
  oh('Ohio', 'OH'),
  ok('Oklahoma', 'OK'),
  or('Oregon', 'OR'),
  pa('Pennsylvania', 'PA'),
  ri('Rhode Island', 'RI'),
  sc('South Carolina', 'SC'),
  sd('South Dakota', 'SD'),
  tn('Tennessee', 'TN'),
  tx('Texas', 'TX'),
  ut('Utah', 'UT'),
  vt('Vermont', 'VT'),
  va('Virginia', 'VA'),
  wa('Washington', 'WA'),
  wv('West Virginia', 'WV'),
  wi('Wisconsin', 'WI'),
  wy('Wyoming', 'WY');

  const State(this.name, this.code);
  final String name;
  final String code;
}
