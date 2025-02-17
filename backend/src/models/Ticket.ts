class Ticket {
  public id!: number;
  public status!: string;
  public userId!: number;
  public companyId!: number;

  constructor(data: Partial<Ticket>) {
    Object.assign(this, data);
  }

  static async findByPk(id: string): Promise<Ticket | null> {
    // Implementação temporária
    return new Ticket({ id: parseInt(id, 10) });
  }
}

export default Ticket;