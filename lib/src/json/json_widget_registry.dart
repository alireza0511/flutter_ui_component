import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'json_widget_builders.dart';

class UberJsonWidgetRegistry {
  static JsonWidgetRegistry createRegistry() {
    final registry = JsonWidgetRegistry.instance;
    
    // Register our custom widget builders
    // UberJsonWidgetBuilders.builders.forEach((type, builder) {
    //   registry.registerCustomBuilder(type, JsonWidgetBuilderContainer(builder: ));
    // });
    
    return registry;
  }
  
  static void initialize() {
    createRegistry();
  }
}