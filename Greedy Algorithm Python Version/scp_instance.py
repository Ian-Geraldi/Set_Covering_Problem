class scpInstance:
    def __init__(self, filename: str):
        with open(filename, 'r') as f:
            s = f.read()
        
        values = s.split()

        v = 0  # iterator for values
        self.num_lin = int(values[v])
        
        v += 1  # v=1
        self.num_col = int(values[v])
        
        v += 1  # v=2
        self.v_cost = [int(values[v + j]) for j in range(self.num_col)]

        v += self.num_col  # v = num_col + 2
        
        self.m_coverage = [[0] * self.num_col for _ in range(self.num_lin)]

        for i in range(self.num_lin):
            v += 1
            cl = int(values[v])

            for _ in range(cl):
                v += 1
                j = int(values[v]) - 1  # adjust for 0-indexing in Python
                self.m_coverage[i][j] = 1