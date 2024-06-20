import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider <int> ((ref) => 3);
final submitProvider = StateProvider <bool?> ((ref) => null);