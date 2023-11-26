const config = require('semantic-release-preconfigured-conventional-commits')
const publishCommands = `
nix-shell -p nixfmt --run "nixfmt hp-15s-eq2004nl-configuration/*.nix"  || exit 1
nix-shell -p nixfmt --run "nixfmt shells/*.nix" || exit 2
git add -A || exit 3
git commit -m "chore: [skip ci] format code in .nix files" || exit 4
git push --force origin || exit 5
git tag -a -f \${nextRelease.version} \${nextRelease.version} -F CHANGELOG.md || exit 6
git push --force origin \${nextRelease.version} || exit 7
`
const releaseBranches = ["main"]
config.branches = releaseBranches
config.plugins.push(
    ["@semantic-release/exec", {
        "publishCmd": publishCommands,
    }],
    ["@semantic-release/github", {
        "assets": [
            { "path": "scripts/" },
            { "path": "shells/" },
            { "path": "hp-15s-eq2004nl-configuration/" },
        ]
    }],
    ["@semantic-release/git", {
        "assets": ["CHANGELOG.md", "package.json"],
        "message": "chore(release)!: [skip ci] ${nextRelease.version} released"
    }],
)
module.exports = config
