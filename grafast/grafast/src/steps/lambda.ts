import type {
  ExecutionExtra,
  GrafastResultsList,
  GrafastValuesList,
  PromiseOrDirect,
} from "../interfaces.js";
import type { ExecutableStep } from "../step.js";
import { UnbatchedExecutableStep } from "../step.js";
import { list } from "./list.js";

/**
 * Calls the given lambda function for each tuple
 */
export class LambdaStep<TIn, TOut> extends UnbatchedExecutableStep<TOut> {
  static $$export = {
    moduleName: "grafast",
    exportName: "LambdaStep",
  };
  // Lambda is only sync and safe if the callback is; so default to false
  isSyncAndSafe = false;
  allowMultipleOptimizations = true;

  private planDep: number | null;
  constructor(
    $plan: ExecutableStep<TIn> | null | undefined,
    private fn: (value: TIn) => TOut,
  ) {
    super();
    this.planDep = $plan != null ? this.addDependency($plan) : null;
    if ((fn as any).isSyncAndSafe) {
      this.isSyncAndSafe = true;
    }
  }

  toStringMeta() {
    return (this.fn as any).displayName || this.fn.name;
  }

  deduplicate(peers: LambdaStep<any, any>[]): LambdaStep<TIn, TOut>[] {
    return peers.filter((peer) => peer.fn === this.fn);
  }

  execute(values: [GrafastValuesList<TIn>]): GrafastResultsList<TOut> {
    const { planDep } = this;
    if (planDep != null) {
      return values[planDep].map(this.fn);
    } else {
      return values[0].map(this.fn);
    }
  }

  unbatchedExecute(extra: ExecutionExtra, value: TIn): PromiseOrDirect<TOut> {
    return this.fn(value);
  }
}

/**
 * A plan that takes the input `$plan` and feeds each value through the `fn`
 * callback. Note: if you need to pass more than one value, pass a `ListStep`
 * as the `$plan` argument.
 */
function lambda<TIn extends [...any[]], TOut>(
  plans: { [Index in keyof TIn]: ExecutableStep<TIn[Index]> },
  fn: (value: TIn) => TOut,
  isSyncAndSafe?: boolean,
): LambdaStep<TIn, TOut>;
function lambda<TIn, TOut>(
  $plan: ExecutableStep<TIn> | null | undefined,
  fn: (value: TIn) => TOut,
  isSyncAndSafe?: boolean,
): LambdaStep<TIn, TOut>;
function lambda(
  planOrPlans: ExecutableStep | ExecutableStep[] | null | undefined,
  fn: (value: any) => any,
  isSyncAndSafe = false,
): LambdaStep<any, any> {
  if (fn.length > 1) {
    throw new Error(
      "lambda callback should accept one argument, perhaps you forgot to destructure the arguments?",
    );
  }
  const $lambda = Array.isArray(planOrPlans)
    ? new LambdaStep<any, any>(list(planOrPlans), fn)
    : new LambdaStep<any, any>(planOrPlans, fn);
  if (isSyncAndSafe) {
    $lambda.isSyncAndSafe = true;
  }
  return $lambda;
}

export { lambda };