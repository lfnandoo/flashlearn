import { exec } from "child_process";

export default (api) => {
  api.hook("chat.message", async (_msg, next) => {
    exec("~/.flashlearn/scripts/flashlearn-hook.sh");
    return next();
  });
};
