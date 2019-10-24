defmodule Conduit.Blog.Process.UnpublishPost do
  use Commanded.ProcessManagers.ProcessManager,
    application: Conduit.App,
    name: "Blog.Process.UnpublishPost"
end
