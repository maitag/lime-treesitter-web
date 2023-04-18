package;

class Main extends lime.app.Application {
	
	public override function render(context:lime.graphics.RenderContext):Void {		
		switch (context.type) {			
			case OPENGL, OPENGLES, WEBGL:				
				var gl = context.webgl;				
				gl.clearColor (0.75, 1, 0, 1);
				gl.clear (gl.COLOR_BUFFER_BIT);			
			default:			
		}		
	}
	
	
	public function new() {
		
		super ();
		
		// invoking tree-sitter.js and its .wasm
		js.Syntax.code("
			const Parser = window.TreeSitter;
			Parser.init().then( () => {
				const parser = new Parser;
				// loading the language grammar (js into this case)
				const glsl = Parser.Language.load('lib/tree-sitter-glsl.wasm').then ( (GLSL) => {
					parser.setLanguage(GLSL);
					this.treeSitterIsReady(parser);
				});
			});
		");
		
	}
	
	
	public function treeSitterIsReady(parser:Dynamic) {
		
		// trace("ready", parser);
		
		var sourceCode = 'let x = 1; console.log(x);';
		
		var tree = parser.parse(sourceCode);
		//js.Syntax.code("console.log(tree);");
		
		trace( tree.rootNode.toString() );
		
		var callExpression = tree.rootNode.child(1).firstChild;
		trace(callExpression);

		
		var newSourceCode = 'let x = "a"; console.log(x);';

		tree.edit({
		  startIndex: 8,
		  oldEndIndex: 9,
		  newEndIndex: 11,
		  startPosition: {row: 0, column: 8},
		  oldEndPosition: {row: 0, column: 9},
		  newEndPosition: {row: 0, column: 11},
		});

		var newTree = parser.parse(newSourceCode, tree);
		trace( newTree.rootNode.toString() );
	}
	
	
	
	
}