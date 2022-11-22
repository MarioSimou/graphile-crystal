import type { PluginHook, PluginHookObject } from "./interfaces.js";
import { sortWithBeforeAfterProvides } from "./sort.js";

export type HookObject<T> = Record<
  keyof T,
  PluginHook<(...args: any[]) => any>
>;

export class AsyncHooks<THooks extends HookObject<THooks>> {
  callbacks: {
    [key in keyof THooks]?: Array<
      THooks[keyof THooks] extends PluginHook<infer U> ? U : never
    >;
  } = {};

  hook<THookName extends keyof THooks>(
    event: THookName,
    fn: THooks[THookName] extends PluginHook<infer U> ? U : never,
  ): void {
    this.callbacks[event] = this.callbacks[event] || [];
    this.callbacks[event]!.push(fn);
  }

  /**
   * Hooks can _mutate_ the argument, they cannot return a replacement. This
   * allows us to completely side-step the problem of recursive calls.
   */
  async process<THookName extends keyof THooks>(
    event: THookName,
    ...args: Parameters<
      THooks[THookName] extends PluginHook<infer U> ? U : never
    >
  ): Promise<void> {
    const [arg, ...rest] = args;
    const callbacks = this.callbacks[event];
    if (callbacks) {
      for (const callback of callbacks!) {
        await callback(arg, ...rest);
      }
    }
  }
}

export function applyHooks<THooks extends HookObject<THooks>>(
  plugins: GraphileConfig.Plugin[],
  hooksRetriever: (
    plugin: GraphileConfig.Plugin,
  ) => Partial<THooks> | undefined,
  applyHookCallback: <THookName extends keyof THooks>(
    hookName: THookName,
    hookFn: THooks[THookName] extends PluginHook<infer U> ? U : never,
    plugin: GraphileConfig.Plugin,
  ) => void,
): void {
  type FullHookSpec = {
    id: string;
    plugin: GraphileConfig.Plugin;
    provides: string[];
    before: string[];
    after: string[];
    callback: THooks[keyof THooks] extends PluginHook<infer U> ? U : never;
  };
  // Normalize all the hooks and gather them into collections
  const allHooks: {
    [key in keyof THooks]?: Array<FullHookSpec>;
  } = Object.create(null);
  let uid = 0;
  for (const plugin of plugins) {
    const hooks = hooksRetriever(plugin);
    if (!hooks) {
      continue;
    }
    const keys = Object.keys(hooks) as unknown as Array<keyof typeof hooks>;
    for (const key of keys) {
      const hookSpecRaw: THooks[typeof key] | undefined = hooks[key];
      if (!hookSpecRaw) {
        continue;
      }

      // TypeScript nonsense
      const isPluginHookObject = <T extends (...args: any[]) => any>(
        v: PluginHook<T>,
      ): v is PluginHookObject<T> => typeof v !== "function";
      const isPluginHookFunction = <T extends (...args: any[]) => any>(
        v: PluginHook<T>,
      ): v is T => typeof v === "function";

      const callback: THooks[typeof key] extends PluginHook<infer U>
        ? U
        : never = (
        isPluginHookFunction(hookSpecRaw) ? hookSpecRaw : hookSpecRaw.callback
      ) as any;
      const { provides, before, after } = isPluginHookObject(hookSpecRaw)
        ? hookSpecRaw
        : ({} as { provides?: never[]; before?: never[]; after?: never });
      if (!allHooks[key]) {
        allHooks[key] = [];
      }
      // We need to give each hook a unique ID
      const id = String(uid++);
      allHooks[key]!.push({
        id,
        plugin,
        callback,
        provides: [...(provides || []), id],
        before: before || [],
        after: after || [],
      });
    }
  }

  // Sort the collections according to provides, before and after.
  for (const hookName in allHooks) {
    const hooks = allHooks[hookName] as FullHookSpec[] | undefined;
    if (!hooks) {
      continue;
    }

    const final = sortWithBeforeAfterProvides(hooks, "id");

    // Finally we can register the hooks
    for (const hook of final) {
      applyHookCallback(hookName, hook.callback, hook.plugin);
    }
  }
}
