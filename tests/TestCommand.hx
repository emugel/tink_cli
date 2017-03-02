package;

import tink.Cli;
import tink.unit.Assert.*;

using tink.CoreApi;

class TestCommand {
	public function new() {}
	
	
	@:describe('Default Command')
	public function testDefault() {
		var command = new EntryCommand();
		
		return Cli.process(['arg', 'other'], command)
			.map(function(code) return equals('defaultAction arg,other', command.result()));
	}
	
	@:describe('Unnamed Command')
	public function testUnnamed() {
		var command = new EntryCommand();
		return Cli.process(['install', 'mypath'], command)
			.map(function(code) return equals('install mypath', command.result()));
	}
	
	@:describe('Named Command')
	public function testNamed() {
		var command = new EntryCommand();
		return Cli.process(['uninst', 'mypath', '3'], command)
			.map(function(code) return equals('uninstall mypath 3', command.result()));
	}
	
	@:describe('Sub Command')
	public function testSub() {
		var command = new EntryCommand();
		return Cli.process(['init', 'a', 'b', 'c'], command)
			.map(function(code) return equals('defaultInit a,b,c', command.init.result()));
	}
	
	@:describe('Const Result')
	public function testConst() {
		var command = new EntryCommand();
		return Cli.process(['const'], command);
	}
	
	@:describe('Success Result')
	public function testSuccess() {
		var command = new EntryCommand();
		return Cli.process(['success'], command);
	}
	
	@:describe('Failure Result')
	public function testFailure() {
		var command = new EntryCommand();
		return Cli.process(['failure'], command)
			.map(function(result) return isFalse(result.isSuccess()));
	}
	
	@:describe('Future Const Result')
	public function testFutureConst() {
		var command = new EntryCommand();
		return Cli.process(['futureConst'], command);
	}
	
	@:describe('Future Success Result')
	public function testFutureSuccess() {
		var command = new EntryCommand();
		return Cli.process(['futureSuccess'], command);
	}
	
	@:describe('Future Failure Result')
	public function testFutureFailure() {
		var command = new EntryCommand();
		return Cli.process(['futureFailure'], command)
			.map(function(result) return isFalse(result.isSuccess()));
	}
	
}

class EntryCommand extends DebugCommand {
	
	@:command('init')
	public var init = new InitCommand();
	
	@:command
	public function install(path:String) {
		debug = 'install $path';
	}
	
	@:command('uninst')
	public function uninstall(path:String, retries:Int) {
		debug = 'uninstall $path $retries';
	}
	
	@:defaultCommand
	public function defaultAction(args:Array<String>) {
		debug = 'defaultAction ' + args.join(',');
	}
	
	
	@:command public function const() return 'Done';
	@:command public function success() return Success('Done');
	@:command public function failure() return Failure(new Error('Errored'));
	@:command public function futureConst() return Future.sync('Done');
	@:command public function futureSuccess() return Future.sync(Success('Done'));
	@:command public function futureFailure() return Future.sync(Failure(new Error('Errored')));
}

class InitCommand extends DebugCommand{
	@:defaultCommand
	public function defaultInit(args:Array<String>) {
		debug = 'defaultInit ' + args.join(',');
	}
}