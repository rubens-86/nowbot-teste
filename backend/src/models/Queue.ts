class Queue {
  public id!: number;
  public name!: string;
  public color!: string;
  public companyId!: number;

  constructor(data: Partial<Queue>) {
    Object.assign(this, data);
  }
}

export default Queue; 