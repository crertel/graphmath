1;
% Octave reference checker for graphmath. Usage:
%   mix run bench/octave/gen_cases.exs /tmp/cases.m
%   octave-cli --no-gui bench/octave/check.m /tmp/cases.m
% Recomputes every case from the documented conventions (row-major tuples,
% row-vector transforms => expected matrix is R^T, right-handed CCW rotations,
% OpenGL depth, Hamilton product on {w,x,y,z}) and prints per-function max error.
% Reference implementations. Matrices arrive as flat row-major tuples.
function M = mat(v) n = sqrt(numel(v)); M = reshape(v, n, n)'; end
function v = flat(M) v = reshape(M', 1, []); end
function u = nrm(v) u = v / norm(v); end
% quaternion {w,x,y,z} Hamilton product
function r = qmul(p, q)
  w = p(1)*q(1) - dot(p(2:4), q(2:4));
  v = p(1)*q(2:4) + q(1)*p(2:4) + cross(p(2:4), q(2:4));
  r = [w v];
end
% column-vector rotation matrix from unit quaternion
function R = q2R(q)
  w=q(1);x=q(2);y=q(3);z=q(4);
  R = [1-2*(y*y+z*z), 2*(x*y-w*z), 2*(x*z+w*y);
       2*(x*y+w*z), 1-2*(x*x+z*z), 2*(y*z-w*x);
       2*(x*z-w*y), 2*(y*z+w*x), 1-2*(x*x+y*y)];
end
function R = axang(k, th)  % Rodrigues, column convention
  K = [0 -k(3) k(2); k(3) 0 -k(1); -k(2) k(1) 0];
  R = eye(3) + sin(th)*K + (1-cos(th))*K*K;
end
function M = orient_ref(p, f, up)
  f = nrm(f); right = nrm(cross(f, nrm(up))); u = cross(right, f);
  M = [right 0; u 0; -f 0; p 1];
end
function e = ref(c)
  a = c.a; e = [];
  nm = c.name; p = strsplit(nm, '.'); mod = p{1}; fn = p{2};
  switch mod
  case {'v2','v3','v4'}
    switch fn
    case 'add', e = a{1}+a{2};
    case 'subtract', e = a{1}-a{2};
    case 'multiply', e = a{1}.*a{2};
    case 'scale', e = a{1}*a{2};
    case 'dot', e = dot(a{1},a{2});
    case 'cross', e = cross(a{1},a{2});
    case 'length', e = norm(a{1});
    case 'length_squared', e = dot(a{1},a{1});
    case 'length_manhattan', e = sum(abs(a{1}));
    case 'chebyshev_distance', e = max(abs(a{1}-a{2}));
    case 'minkowski_distance', e = sum(abs(a{1}-a{2}).^a{3})^(1/a{3});
    case 'p_norm', e = sum(abs(a{1}).^a{2})^(1/a{2});
    case 'lerp', e = (1-a{3})*a{1} + a{3}*a{2};
    case 'negate', e = -a{1};
    case 'normalize', e = nrm(a{1});
    case 'project', e = dot(a{1},a{2})/dot(a{2},a{2}) * a{2};
    case 'perp', e = [-a{1}(2) a{1}(1)];
    case 'perp_prod', e = a{1}(1)*a{2}(2) - a{2}(1)*a{1}(2);
    case 'rotate'
      if strcmp(mod,'v2'), th=a{2}; e = ([cos(th) -sin(th); sin(th) cos(th)]*a{1}')';
      else e = (axang(a{2}, a{3})*a{1}')'; end
    case 'scalar_triple', e = dot(a{1}, cross(a{2}, a{3}));
    case 'weighted_sum', e = a{1}*a{2} + a{3}*a{4};
    case 'near', e = norm(a{1}-a{2}) < a{3};
    case 'equal3', e = all(abs(a{1}-a{2}) <= a{3});
    case 'equal', e = all(a{1}==a{2});
    case {'create1','create2','create3','create4'}, e = [a{:}];
    case 'from_point3', e = [a{1} 1];
    case 'from_direction3', e = [a{1} 0];
    case 'random_circle', e = 1; c.out = norm(c.out);
    case 'random_sphere', e = 1; c.out = norm(c.out);
    case {'random_disc','random_ball'}, e = 1; c.out = double(norm(c.out) <= 1);
    case 'random_box', e = 1; c.out = double(all(c.out >= 0 & c.out <= 1));
    end
  case {'m22','m33','m44'}
    n = mod(2) - '0';
    switch fn
    case 'identity', e = flat(eye(n));
    case 'zero', e = zeros(1,n*n);
    case 'add', e = a{1}+a{2};
    case 'subtract', e = a{1}-a{2};
    case 'scale', e = a{1}*a{2};
    case 'multiply', e = flat(mat(a{1})*mat(a{2}));
    case 'multiply_transpose', e = flat(mat(a{1})*mat(a{2})');
    case 'apply', e = (mat(a{1})*a{2}')';
    case 'apply_left', e = a{1}*mat(a{2});
    case 'apply_transpose', e = (mat(a{1})'*a{2}')';
    case 'apply_left_transpose', e = a{1}*mat(a{2})';
    case 'transform_vector'
      if n==2, e = a{2}*mat(a{1}); else v = [a{2} 0]*mat(a{1}); e = v(1:n-1); end
    case 'transform_point', v = [a{2} 1]*mat(a{1}); e = v(1:n-1);
    case 'at', M = mat(a{1}); e = M(a{2}+1, a{3}+1);
    case 'submatrix', M = mat(a{1}); M(a{2}+1,:)=[]; M(:,a{3}+1)=[]; e = flat(M);
    case 'cofactor', M = mat(a{1}); M(a{2}+1,:)=[]; M(:,a{3}+1)=[]; e = (-1)^(a{2}+a{3})*det(M);
    case {'row0','row1','row2','row3'}, M = mat(a{1}); e = M(fn(4)-'0'+1, :);
    case {'column0','column1','column2','column3'}, M = mat(a{1}); e = M(:, fn(7)-'0'+1)';
    case 'diag', e = diag(mat(a{1}))';
    case 'determinant', e = det(mat(a{1}));
    case 'trace', e = trace(mat(a{1}));
    case 'inverse', e = flat(inv(mat(a{1})));
    case 'round', e = round(a{1}*10^a{2})/10^a{2};
    % ---- constructors: row-vector convention => M = R' (R column-convention)
    case 'make_rotate'  % about +Z CCW
      th=a{1}; R = [cos(th) -sin(th); sin(th) cos(th)];
      if n==3, R = blkdiag(R,1); end; e = flat(R');
    case 'make_rotate_x', R = blkdiag(axang([1 0 0], a{1}), 1); e = flat(R');
    case 'make_rotate_y', R = blkdiag(axang([0 1 0], a{1}), 1); e = flat(R');
    case 'make_rotate_z', R = blkdiag(axang([0 0 1], a{1}), 1); e = flat(R');
    case 'make_translate', M = eye(n); M(n, 1:n-1) = [a{:}]; e = flat(M);
    case 'make_scale1', e = flat(eye(n)*a{1});
    case {'make_scale2','make_scale3','make_scale4'}, e = flat(diag([a{:}]));
    case {'make_reflect','make_reflect_3d','make_reflect_2d'}
      nv = a{1}; d = numel(nv); H = eye(d) - 2*(nv'*nv)/dot(nv,nv);
      if numel(a) == 2  % affine: p' = p - 2*((n.p - off)/|n|^2) n
        M = eye(d+1); M(1:d,1:d) = H'; M(d+1,1:d) = 2*a{2}*nv/dot(nv,nv);
      else M = H'; end
      e = flat(M);
    case {'make_shear_x','make_shear_x_2d','make_shear_x_3d'}
      S = eye(n); if n==2 || strcmp(fn,'make_shear_x_2d'), S(1,2)=a{1}; else S(1,2)=a{1}; S(1,3)=a{2}; end
      e = flat(S');
    case {'make_shear_y','make_shear_y_2d','make_shear_y_3d'}
      S = eye(n); if n==2 || strcmp(fn,'make_shear_y_2d'), S(2,1)=a{1}; else S(2,1)=a{1}; S(2,3)=a{2}; end
      e = flat(S');
    case {'make_shear_z','make_shear_z_3d'}
      S = eye(n); S(3,1)=a{1}; S(3,2)=a{2}; e = flat(S');
    case 'orthonormalize'
      A = mat(a{1}); [Q,R] = qr(A'); Q = Q*diag(sign(diag(R))); e = flat(Q');
    case 'orient', e = flat(orient_ref(a{1}, a{2}, a{3}));
    case 'look_at', e = flat(inv(orient_ref(a{1}, a{2}-a{1}, a{3})));
    case 'make_billboard', e = flat(orient_ref(a{1}, a{2}-a{1}, a{3}));
    case 'make_billboard_axis'
      y = nrm(a{3}); d = a{2}-a{1}; d = d - dot(d,y)*y; z = -nrm(d); x = cross(y, z);
      e = flat([x 0; y 0; z 0; a{1} 1]);
    case 'perspective'  % gluPerspective, column convention, then transpose
      fovy=a{1}; asp=a{2}; nr=a{3}; fr=a{4}; f = 1/tan(fovy/2);
      P = [f/asp 0 0 0; 0 f 0 0; 0 0 (fr+nr)/(nr-fr) 2*fr*nr/(nr-fr); 0 0 -1 0];
      e = flat(P');
    case 'ortho'  % glOrtho
      l=a{1};r=a{2};b=a{3};t=a{4};nr=a{5};fr=a{6};
      P = [2/(r-l) 0 0 -(r+l)/(r-l); 0 2/(t-b) 0 -(t+b)/(t-b); 0 0 -2/(fr-nr) -(fr+nr)/(fr-nr); 0 0 0 1];
      e = flat(P');
    end
  case 'q'
    switch fn
    case 'identity', e = [1 0 0 0];
    case 'zero', e = [0 0 0 0];
    case {'create','from_list'}, e = [a{:}];
    case 'add', e = a{1}+a{2};
    case 'subtract', e = a{1}-a{2};
    case 'multiply', e = qmul(a{1}, a{2});
    case 'scale', e = a{1}*a{2};
    case 'dot', e = dot(a{1},a{2});
    case 'norm', e = norm(a{1});
    case {'normalize','normalize_strict'}, e = nrm(a{1});
    case 'conjugate', e = a{1}.*[1 -1 -1 -1];
    case 'inverse', e = a{1}.*[1 -1 -1 -1]/dot(a{1},a{1});
    case 'equal', e = abs(dot(a{1},a{2})) >= 1;
    case 'equal_elements', e = all(abs(a{1}-a{2}) <= a{3});
    case 'from_axis_angle', e = [cos(a{1}/2) sin(a{1}/2)*a{2}];
    case 'to_rotation_matrix_33', e = flat(q2R(a{1})');
    case 'to_rotation_matrix_44', e = flat(blkdiag(q2R(a{1})', 1));
    case 'transform_vector', e = (q2R(a{1})*a{2}')';
    case 'from_rotation_matrix'
      % compare as orientation: q2R(out)' must equal input matrix
      e = a{1}; c.out = flat(q2R(nrm(c.out))');
    case 'slerp'
      p = a{1}; q = a{2}; t = a{3}; d = dot(p,q);
      if d < 0, q = -q; d = -d; end
      if d > 1 - 1e-9, e = nrm((1-t)*p + t*q);
      else th = acos(min(d,1)); e = (sin((1-t)*th)*p + sin(t*th)*q)/sin(th); end
      if dot(e, c.out) < 0, c.out = -c.out; end  % same orientation, either sign
    case 'integrate'
      q = a{1}; om = a{2}; dt = a{3}; th = norm(om)*dt;
      if th == 0, dq = [1 0 0 0]; else dq = [cos(th/2) sin(th/2)*om/norm(om)]; end
      e = nrm(qmul(dq, q));
    case 'random', e = 1; c.out = norm(c.out);
    case {'get_roll_z','get_pitch_x','get_yaw_y'}, e = a{1};
    case 'euler'
      % Ogre convention: roll about Z, pitch about X, yaw about Y; check each
      % extractor against the quaternion's rotation matrix.
      R = q2R(nrm(a{1}));
      e = [atan2(R(2,1), R(1,1)), atan2(R(3,2), R(2,2)), atan2(R(1,3), R(3,3))];
    end
  end
  e = double(e); c.out = double(c.out);
  if isempty(e), error('no reference for %s', nm); end
  if numel(e) ~= numel(c.out), error('shape mismatch for %s: %d vs %d', nm, numel(e), numel(c.out)); end
  e = max(abs(e(:) - c.out(:)) ./ max(1, abs(e(:))));  % relative-ish error
end

function s = ifelse_str(b) if b, s = "  <-- FAIL"; else s = ""; end; end
run(argv(){1});
names = cellfun(@(c) c.name, C, 'UniformOutput', false);
[u, ~, idx] = unique(names);
worst = zeros(size(u));
for k = 1:numel(C)
  if strncmp(C{k}.name,'err.',4) || strncmp(C{k}.name,'edge.',5), continue; end
  if ~isequal(C{k}.err, 0), fprintf('RAISED %s %s\n', C{k}.name, C{k}.err); continue; end
  err = ref(C{k});
  worst(idx(k)) = max(worst(idx(k)), err);
  if err > 1e-9
    fprintf('MISMATCH %-28s err=%.3e case=%d\n', C{k}.name, err, k);
  end
end
fprintf('\n%-28s %s\n', 'function', 'max err');
for i = 1:numel(u), fprintf('%-28s %.2e %s\n', u{i}, worst(i), ifelse_str(worst(i) > 1e-9)); end
