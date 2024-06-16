const publishCommands = `
git tag -a -f \${nextRelease.version} \${nextRelease.version} -F CHANGELOG.md || exit 1
git push --force origin \${nextRelease.version} || exit 2
`
const config = {
  branches: ["main"],
};
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
