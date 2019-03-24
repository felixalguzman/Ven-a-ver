library serializers;

import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:ven_a_ver/src/movie.dart';

part 'serializers.g.dart';


@SerializersFor(const [Movie,])

Serializers serializers = _$serializers;

Serializers standartSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
