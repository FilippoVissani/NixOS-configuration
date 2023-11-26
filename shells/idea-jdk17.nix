{
	pkgs ? import <nixpkgs> {}
}:

(
	pkgs.buildFHSUserEnv
	{
		name = "foo";
		targetPkgs = pkgs:
		[
			pkgs.jetbrains.idea-ultimate
			pkgs.jdk17
      pkgs.kotlin
		];
	}
).env

