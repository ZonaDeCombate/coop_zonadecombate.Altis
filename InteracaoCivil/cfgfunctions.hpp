class SCI
{
	tag = "SCI";
	class functions
	{
		class civilianInteraction {
			description = "Main handler for civilian interaction";
			file = "InteracaoCivil\fn_civilianInteraction.sqf";
			recompile = RECOMPILE;
		};

		class commandHandler {
			description = "Main handler for commands";
			file = "InteracaoCivil\fn_commandHandler.sqf";
			recompile = RECOMPILE;
		};
		class questionHandler {
			description = "Retrieves responses for passed question";
			file = "InteracaoCivil\fn_questionHandler.sqf";
			recompile = RECOMPILE;
		};

	};
};