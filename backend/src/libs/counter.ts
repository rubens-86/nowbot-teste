export class CounterManager {
  private counters: Map<string, number>;

  constructor() {
    this.counters = new Map();
  }

  public incrementCounter(key: string): number {
    const currentValue = this.counters.get(key) || 0;
    const newValue = currentValue + 1;
    this.counters.set(key, newValue);
    return newValue;
  }

  public decrementCounter(key: string): number {
    const currentValue = this.counters.get(key) || 0;
    const newValue = Math.max(0, currentValue - 1);
    this.counters.set(key, newValue);
    return newValue;
  }

  public getCounter(key: string): number {
    return this.counters.get(key) || 0;
  }
}
