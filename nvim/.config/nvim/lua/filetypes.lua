vim.filetype.add({
	filename = {
		[".gitlab-ci.yml"] = "yaml.gitlab",
		[".gitlab-ci.yaml"] = "yaml.gitlab",
	},
	pattern = {
		["docker%-compose.*%.ya?ml.*"] = "yaml.docker-compose",
		["compose.*%.ya?ml.*"] = "yaml.docker-compose",
		[".*%.gitlab%-ci.*%.ya?ml"] = "yaml.gitlab",
	},
})
