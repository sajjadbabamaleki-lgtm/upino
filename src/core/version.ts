/**
 * Engine version. Per INV-07, identical snapshot inputs plus an identical engine
 * version must produce identical outputs, so this value is part of every
 * PlanSnapshot and must be bumped whenever allocation or Safe-to-Spend
 * behaviour changes.
 */
export const ENGINE_VERSION = '0.1.0' as const;

/** Specification this engine implements. */
export const SPEC_VERSION = 'Upino Product Foundation v3.5 (Frozen G0)' as const;
