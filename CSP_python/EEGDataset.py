import torch
from torch.utils.data import Dataset
import numpy as np

class EEGDataset(Dataset):
	def __init__(self, X, y, transform=None):
		if len(X.shape) == 3:
			X = X[:, np.newaxis, :, :]
		if len(y.shape) == 1:
			y = self._onehot_encoding(y)

		self.X = X
		self.y = y
		self.transform = transform

	def __len__(self):
		return len(self.y)
	
	def __getitem__(self, idx):
		if torch.is_tensor(idx):
			idx = idx.tolist()

		sample = {'data': self.X[idx], 'labels': self.y[idx]}
		if self.transform:
			sample = self.transform(sample)
		
		return sample
	
	def _onehot_encoding(self, data):
		num = np.max(data).astype('int') + 1
		return np.squeeze(np.eye(num)[data.astype('int')])
