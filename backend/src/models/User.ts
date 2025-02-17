class User {
  public id!: number;
  public name!: string;
  public email!: string;
  public profile!: string;
  public online!: boolean;
  public companyId!: number;
  public queues!: any[];
  public allTicket!: string;

  constructor(data: Partial<User>) {
    Object.assign(this, data);
  }

  static async findByPk(id: number, options?: any): Promise<User | null> {
    // Implementação temporária
    return new User({ id, queues: [] });
  }

  async save(): Promise<void> {
    // Implementação temporária
  }
}

export default User; 