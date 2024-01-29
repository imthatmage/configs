return {
	"mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap-python",
    },
	config = function()
        local dap, dapui = require("dap"), require("dapui")

        require("dap-python").setup()
        require("dapui").setup()
        dap.listeners.before.attach.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
          dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
                end
  dapui.close()

		vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, {})
        -- thing that start dap server
		vim.keymap.set("n", "<leader>dc", dap.continue, {})
	end,
}
