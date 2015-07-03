// The MIT License
//
// Copyright (c) 2015 Gwendal Roué
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


extension StandardLibrary {
    
    public class Localizer : MustacheBoxable {
        public let bundle: NSBundle
        public let table: String?
        var formatArguments: [String]?
        
        /**
        Returns a localizing helper.
        
        :param: bundle The bundle where to look for localized strings. If nil,
                       the main bundle is used.
        :param: table  The table where to look for localized strings. If nil,
                       the default Localizable.strings table would be used.
        */
        public init(bundle: NSBundle?, table: String?) {
            self.bundle = bundle ?? NSBundle.mainBundle()
            self.table = table
        }
        
        public var mustacheBox: MustacheBox {
            // Return a multi-facetted box, because Localizer interacts in
            // various ways with Mustache rendering.
            return Box(
                // It has a value
                value: self,
                
                // Localizer can be used as a filter: {{ localize(x) }}:
                filter: Filter(filter),
                
                // Localizer performs custom rendering, so that it can localize
                // the sections it is attached to: {{# localize }}Hello{{/ localize }}.
                render: render,
                
                // Localizer needs to observe the rendering of variables tags
                // inside the section it is attached to: {{# localize }}Hello {{ name }}{{/ localize }}.
                willRender: willRender,
                didRender: didRender)
        }
        
        // This function is used for evaluating `localize(x)` expressions.
        private func filter(rendering: Rendering, error: NSErrorPointer) -> Rendering? {
            return Rendering(localizedStringForKey(rendering.string), rendering.contentType)
        }
        
        // This functionis used to render a {{# localize }}Hello{{/ localize }} section.
        private func render(info: RenderingInfo, error: NSErrorPointer) -> Rendering? {
            
            // Perform a first rendering of the section tag, that will turn
            // variable tags into a custom placeholder.
            //
            // "...{{name}}..." will get turned into "...GRMustacheLocalizerValuePlaceholder...".
            //
            // For that, we make sure we are notified of tag rendering, so that
            // our willRender(tag: Tag, box:) method has the tags render
            // GRMustacheLocalizerValuePlaceholder instead of the regular values.
            //
            // This behavior of willRender() is trigerred by the nil value of
            // self.formatArguments:
            
            formatArguments = nil
            
            
            // Push self in the context stack in order to trigger our
            // willRender() method.
            
            let context = info.context.extendedContext(Box(self))
            
            
            // Render the localizable format string
            
            if let localizableFormatRendering = info.tag.renderInnerContent(context, error: error) {
                
                // Now perform a second rendering that will fill our
                // formatArguments array with HTML-escaped tag renderings.
                //
                // Now our willRender() method will let the tags render regular
                // values. Our didRender() method will grab those renderings,
                // and fill self.formatArguments.
                //
                // This behavior of willRender() is not the same as the previous
                // one, and is trigerred by the non-nil value of
                // self.formatArguments:
                
                formatArguments = []
                
                
                // Render again
                
                info.tag.renderInnerContent(context)
                
                
                let rendering: Rendering
                if formatArguments!.isEmpty
                {
                    // There is no format argument, which means no inner
                    // variable tag: {{# localize }}plain text{{/ localize }}
                    rendering = Rendering(localizedStringForKey(localizableFormatRendering.string), localizableFormatRendering.contentType)
                }
                else
                {
                    // There are format arguments, which means inner variable
                    // tags: {{# localize }}...{{ name }}...{{/ localize }}.
                    //
                    // Take special precaution with the "%" character:
                    //
                    // When rendering {{#localize}}%d {{name}}{{/localize}},
                    // the localizable format we need is "%%d %@".
                    //
                    // Yet the localizable format we have built so far is
                    // "%d GRMustacheLocalizerValuePlaceholder".
                    //
                    // In order to get an actual format string, we have to:
                    // - turn GRMustacheLocalizerValuePlaceholder into %@
                    // - escape % into %%.
                    //
                    // The format string will then be "%%d %@", as needed.
                    
                    let localizableFormat = localizableFormatRendering.string.stringByReplacingOccurrencesOfString("%", withString: "%%").stringByReplacingOccurrencesOfString(Placeholder.string, withString: "%@")
                    
                    // Now localize the format
                    let localizedFormat = localizedStringForKey(localizableFormat)
                    
                    // Apply arguments
                    let localizedRendering = stringWithFormat(format: localizedFormat, argumentsArray: formatArguments!)
                    
                    // And we have the final rendering
                    rendering = Rendering(localizedRendering, localizableFormatRendering.contentType)
                }
                
                
                // Clean up
                
                formatArguments = nil
                
                
                // Done
                
                return rendering
            } else {
                // Error in the rendering of the inner content of the localized
                // section
                return nil
            }
        }
        
        private func willRender(tag: Tag, box: MustacheBox) -> MustacheBox {
            switch tag.type {
            case .Variable:
                // {{ value }}
                //
                // We behave as stated in the documentation of render():
                
                if formatArguments == nil {
                    return Box(Placeholder.string)
                } else {
                    return box
                }
                
            case .Section:
                // {{# value }}
                // {{^ value }}
                //
                // We do not want to mess with Mustache handling of boolean and
                // loop sections such as {{#true}}...{{/}}.
                return box
            }
        }
        
        private func didRender(tag: Tag, box: MustacheBox, string: String?) {
            switch tag.type {
            case .Variable:
                // {{ value }}
                //
                // We behave as stated in the documentation of render():
                
                if formatArguments != nil {
                    if let string = string {
                        formatArguments!.append(string)
                    }
                }
                
            case .Section:
                // {{# value }}
                // {{^ value }}
                break
            }
        }
        
        private func localizedStringForKey(key: String) -> String {
            return bundle.localizedStringForKey(key, value:"", table:table)
        }
        
        private func stringWithFormat(#format: String, argumentsArray args:[String]) -> String {
            switch count(args) {
            case 0:
                return format
            case 1:
                return String(format: format, args[0])
            case 2:
                return String(format: format, args[0], args[1])
            case 3:
                return String(format: format, args[0], args[1], args[2])
            case 4:
                return String(format: format, args[0], args[1], args[2], args[3])
            case 5:
                return String(format: format, args[0], args[1], args[2], args[3], args[4])
            case 6:
                return String(format: format, args[0], args[1], args[2], args[3], args[4], args[5])
            case 7:
                return String(format: format, args[0], args[1], args[2], args[3], args[4], args[5], args[6])
            case 8:
                return String(format: format, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7])
            case 9:
                return String(format: format, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8])
            case 10:
                return String(format: format, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9])
            default:
                fatalError("Not implemented: format with \(count(args)) parameters")
            }
        }
        
        struct Placeholder {
            static let string = "GRMustacheLocalizerValuePlaceholder"
        }
    }

}
